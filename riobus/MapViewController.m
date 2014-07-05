//
//  MapViewController.m
//  riobus
//
//  Created by Bruno do Amaral on 04/07/2014.
//  Copyright (c) 2014 Rio Bus. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>
#import "BusDataStore.h"
#import <Toast/Toast+UIView.h>

@interface MapViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager ;
@property (strong, nonatomic) NSMutableDictionary *markerForOrder;
@property (weak, nonatomic) NSOperation *lastRequest ;
@property (strong, nonatomic) NSArray *busesData ;
@property (weak, nonatomic) IBOutlet UITextField *searchInput;
@property (strong, nonatomic) NSTimer *updateTimer ;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [prefs integerForKey:@"Tipo"];
    
    self.markerForOrder = [[NSMutableDictionary alloc] initWithCapacity:100];

    self.locationManager.delegate = self ;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters ;
    [self.locationManager startUpdatingLocation];
    
    if (myInt == 0){
        self.mapView.mapType = kGMSTypeNormal;
    }else{
        self.mapView.mapType = kGMSTypeHybrid;
    }
    BOOL trafego = [prefs boolForKey:@"Transito"];
    self.mapView.trafficEnabled = trafego;
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (CLLocationManager *)locationManager
{
    // Lazy initialization
    if (!_locationManager) _locationManager = [[CLLocationManager alloc] init];
    return _locationManager ;
}

-(void)aTime{
    
    if(![self.searchInput isFirstResponder])
        [self atualizar:self];
    
}


- (IBAction)searchClick:(id)sender {
    [self.searchInput resignFirstResponder];
    [self atualizar:self];
    [self.markerForOrder removeAllObjects];
    [self.mapView clear];
}

- (void)atualizar:(id)sender {
    [self.searchInput resignFirstResponder];
    
    if ( self.lastRequest ) {
        NSLog(@"Cancelando o request antigo %@", self.lastRequest);
        [self.lastRequest cancel];
    }
    
    if ( self.searchInput.text.length > 0 ) {
        self.lastRequest = [[BusDataStore sharedInstance] loadBusDataForLineNumber:self.searchInput.text withCompletionHandler:^(NSArray *busesData, NSError *error) {
            if ( error ) {
                // Mostra Toast parecido com o Android
                if ( error.code != NSURLErrorCancelled ) { // Erro ao cancelar um request
                    [self.view makeToast:[error localizedDescription]];
                }
                
                // Atualiza informacoes dos marcadores
                [self updateMarkers];
            } else {
                self.busesData = busesData ;
                
                if ( self.busesData.count == 0 ) {
                    NSString *msg = [NSString stringWithFormat:@"Nenhum resultado para a linha %@", self.searchInput.text];
                    [self.view makeToast:msg];
                } else {
                    // Ajusta o timer
                    [self.updateTimer invalidate];
                    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(aTime) userInfo:nil repeats:NO];
                }
            }
        }];
    }
}

- (void)setBusesData:(NSArray *)busesData
{
    _busesData = busesData ;
    [self updateMarkers];
}

- (void)updateMarkers
{
    [self.busesData enumerateObjectsUsingBlock:^(BusData *busData, NSUInteger idx, BOOL *stop) {
        NSInteger delayInformation = [busData delayInMinutes];
        
        // Busca o marcador na "cache"
        GMSMarker *marca = self.markerForOrder[busData.order];
        if ( !marca ) {
            marca = [[GMSMarker alloc] init];
            [marca setMap:self.mapView];
            [self.markerForOrder setValue:marca forKey:busData.order];
        }
        
        marca.title = [busData.lineNumber description] ;
        marca.snippet = [NSString stringWithFormat:@"Ordem: %@\nVelocidade: %.0f km/h\nAtualizado há %d %@", busData.order, [busData.velocity doubleValue], delayInformation, (delayInformation == 1 ? @"minuto" : @"minutos")];
        marca.position = busData.location.coordinate ;
        
        UIImage *imagem;
        if (delayInformation > 10)
            imagem = [UIImage imageNamed:@"bus-red.png"];
        else if (delayInformation > 5)
            imagem = [UIImage imageNamed:@"bus-yellow.png"];
        else
            imagem = [UIImage imageNamed:@"bus-green.png"];
        
        marca.icon = imagem;
    }];
    
    // Atuzalia infor-window corrente
    if( self.mapView.selectedMarker ) {
        // Forca atualizacao do marcador selecionado
        GMSMarker *selectedMarker = self.mapView.selectedMarker ;
        self.mapView.selectedMarker = nil ;
        self.mapView.selectedMarker = selectedMarker ;
    }    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:11];
}

@end
