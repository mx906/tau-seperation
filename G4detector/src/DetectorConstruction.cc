#include "DetectorConstruction.hh"
#include "PMTSD.hh"

#include "G4RunManager.hh"
#include "G4NistManager.hh"
#include "G4Box.hh"
#include "G4SDManager.hh"

#include "G4Orb.hh"
#include "G4LogicalVolume.hh"
#include "G4PVPlacement.hh"
#include "G4PVReplica.hh"
#include "G4SystemOfUnits.hh"

#include "G4VisAttributes.hh"
#include "G4Colour.hh"

#include "G4VSDFilter.hh"
#include "G4SDParticleFilter.hh"

///////////////////////////////////////////////////////////////////////////////

DetectorConstruction::DetectorConstruction()
: G4VUserDetectorConstruction()
{
	DefineMaterials();
}

///////////////////////////////////////////////////////////////////////////////

DetectorConstruction::~DetectorConstruction()
{ }

///////////////////////////////////////////////////////////////////////////////

void DetectorConstruction::DefineMaterials() {

	 // Get nist material manager
	G4NistManager* nist = G4NistManager::Instance();
	G4double density;
	G4double temp;
	G4int ncomponents;

	// Water
	Water = nist->FindOrBuildMaterial("G4_WATER");
	
	// Seawater
	density = 1.04*g / cm3;
	temp = 283.15*kelvin;
	Seawater = new G4Material("SeaWater", density, ncomponents = 4, kStateLiquid, temp);
	G4Element* Cl = nist->FindOrBuildElement("Cl");
	G4Element* Na = nist->FindOrBuildElement("Na");
	G4Element* Mg = nist->FindOrBuildElement("Mg");
	Seawater->AddMaterial(Water, 96.88 * perCent); //fractional mass
	Seawater->AddElement(Cl, 1.92 * perCent);
	Seawater->AddElement(Na, 1.07 * perCent);
	Seawater->AddElement(Mg, 0.13 * perCent);

	// Material properties tables
	
	G4double photonEnergy[] =
	{ 2.666*eV, 3.061*eV, 3.396*eV};
	const G4int nEntries = sizeof(photonEnergy) / sizeof(G4double);

	G4double refractiveIndex[] =
	{ 1.333, 1.333, 1.333};
	assert(sizeof(refractiveIndex) == sizeof(photonEnergy));

	G4double absorption[] =
	{ 55.0*m, 35.0*m, 30.5*m};
	assert(sizeof(absorption) == sizeof(photonEnergy));

	G4double mie[] =
	{ 32.3*m, 19.0*m, 10.6 * m };
	assert(sizeof(mie) == sizeof(photonEnergy));

	G4double MIE_water_const[3] = { 0.9204, 0.1491, 0.8831 };

	/* Pure water data
	G4double photonEnergy[] =
		{ 2.066*eV, 2.156*eV, 2.254*eV, 2.362*eV, 2.480*eV,
		  2.610*eV, 2.755*eV, 2.917*eV, 3.100*eV, 3.306*eV,
		  3.542*eV, 3.815*eV, 4.133*eV };
	const G4int nEntries = sizeof(photonEnergy) / sizeof(G4double);

	G4double refractiveIndex[] =
		{ 1.333, 1.333, 1.333, 1.333, 1.333,
		  1.333, 1.333, 1.333, 1.333, 1.333,
		  1.333, 1.333, 1.333 };
	assert(sizeof(refractiveIndex) == sizeof(photonEnergy));

	G4double absorption[] =
		{ 4.376*m, 12.644*m, 22.286*m, 31.672*m ,39.790*m,
		  40.427*m, 33.670*m, 26.027*m, 17.081*m, 8.531*m, 
		  4.289*m, 2.394*m, 1.492*m};
	assert(sizeof(absorption) == sizeof(photonEnergy));

	// G. M. Hale and M. R. Querry.
	// Optical constants of water in the 200-nm to 200-µm wavelength region
	*/

	/*old
	G4double photonEnergy[] =
            { 2.034*eV, 2.068*eV, 2.103*eV, 2.139*eV,
              2.177*eV, 2.216*eV, 2.256*eV, 2.298*eV,
              2.341*eV, 2.386*eV, 2.433*eV, 2.481*eV,
              2.532*eV, 2.585*eV, 2.640*eV, 2.697*eV,
              2.757*eV, 2.820*eV, 2.885*eV, 2.954*eV,
              3.026*eV, 3.102*eV, 3.181*eV, 3.265*eV,
              3.353*eV, 3.446*eV, 3.545*eV, 3.649*eV,
              3.760*eV, 3.877*eV, 4.002*eV, 4.136*eV };
	const G4int nEntries = sizeof(photonEnergy) / sizeof(G4double);
	
	G4double refractiveIndex[] =
            { 1.3435, 1.344,  1.3445, 1.345,  1.3455,
              1.346,  1.3465, 1.347,  1.3475, 1.348,
              1.3485, 1.3492, 1.35,   1.3505, 1.351,
              1.3518, 1.3522, 1.3530, 1.3535, 1.354,
              1.3545, 1.355,  1.3555, 1.356,  1.3568,
              1.3572, 1.358,  1.3585, 1.359,  1.3595,
              1.36,   1.3608};
	assert(sizeof(refractiveIndex) == sizeof(photonEnergy));

	G4double absorption[] =
			{ 3.448*m,  4.082*m,  6.329*m,  9.174*m, 12.346*m, 13.889*m,
			  15.152*m, 17.241*m, 18.868*m, 20.000*m, 26.316*m, 35.714*m,
			  45.455*m, 47.619*m, 52.632*m, 52.632*m, 55.556*m, 52.632*m,
			  52.632*m, 47.619*m, 45.455*m, 41.667*m, 37.037*m, 33.333*m,
			  30.000*m, 28.500*m, 27.000*m, 24.500*m, 22.000*m, 19.500*m,
			  17.500*m, 14.500*m };
	assert(sizeof(absorption) == sizeof(photonEnergy));
	
	// from OpNovice example 
	*/

	G4MaterialPropertiesTable* MPT_Seawater = new G4MaterialPropertiesTable();

	MPT_Seawater->AddProperty("RINDEX", photonEnergy, refractiveIndex, nEntries)->SetSpline(true);
	MPT_Seawater->AddProperty("ABSLENGTH", photonEnergy, absorption, nEntries)->SetSpline(true);

	/* pure water, Rayleigh scatteirng only, comment out the following two lines for seawater simulation
	MPT_Seawater->AddConstProperty("ISOTHERMAL_COMPRESSIBILITY", 7.658e-23*m3 / MeV);
	MPT_Seawater->AddProperty("RAYLEIGH", photonEnergy, rayleigh, nEntries)->SetSpline(true);
	*/

	/* sea waterm only MieHG enabled, comment out the following four lines for pure water simulaiton*/
	MPT_Seawater->AddProperty("MIEHG", photonEnergy, mie, nEntries)->SetSpline(true);
	MPT_Seawater->AddConstProperty("MIEHG_FORWARD",MIE_water_const[0]);
	MPT_Seawater->AddConstProperty("MIEHG_BACKWARD",MIE_water_const[1]);
	MPT_Seawater->AddConstProperty("MIEHG_FORWARD_RATIO",MIE_water_const[2])


	Seawater->SetMaterialPropertiesTable(MPT_Seawater);
}

///////////////////////////////////////////////////////////////////////////////

G4VPhysicalVolume* DetectorConstruction::Construct()
{  
  // Parameters
  // Detector size
  G4double world_sizeX = 150 * m, world_sizeY = 150 * m, world_sizeZ = 150 * m;
  G4double box_sizeX = 150 * m, box_sizeY = 150 * m, box_sizeZ = 150 * m;
  G4ThreeVector box_pos = G4ThreeVector(0 * m, 0 * m, 0 * m);
  // PMT size, PMT number can be adjusted in DetectorConstruction.hh
  G4double det_radius = 355 * mm / 2;

  // Check volumes overlaps
  G4bool checkOverlaps = true;

  // World
  G4Box* solidWorld =    
    new G4Box("World", 0.5*world_sizeX, 0.5*world_sizeY, 0.5*world_sizeZ);
      
  G4LogicalVolume* logicWorld =                         
    new G4LogicalVolume(solidWorld, Seawater, "WorldLV"); //solid, material, name
                                 
  G4VPhysicalVolume* physWorld = 
    new G4PVPlacement(0,                     //no rotation
                      G4ThreeVector(),       //at (0,0,0)
                      logicWorld,            //its logical volume
                      "World",               //its name
                      0,                     //its mother volume
                      false,                 //no boolean operation
                      0,                     //copy number
                      checkOverlaps);        //overlaps checking
                     
  // detector box  
  G4Box* solidbox = 
	new G4Box("Box", 0.5*box_sizeX, 0.5*box_sizeY, 0.5*box_sizeZ);
      
  G4LogicalVolume* logicbox =                         
    new G4LogicalVolume(solidbox, Seawater, "BoxLV"); //solid, material, name
               
  new G4PVPlacement(0,                       //rotation
					box_pos,                 //position
                    logicbox,                //its logical volume
                    "Box",                   //its name
                    logicWorld,              //its mother  volume
                    false,                   //no boolean operation
                    0,                       //copy number
                    checkOverlaps);          //overlaps checking
 
  // Layer X
  G4Box* solidLayer =
	  new G4Box("Layer", 0.5*box_sizeX/kDimX, 0.5*box_sizeY, 0.5*box_sizeZ);

  G4LogicalVolume* logicLayer =
	  new G4LogicalVolume(solidLayer, Seawater, "LayerLV");
 
  new G4PVReplica(
	  "Layer",             //its name
	  logicLayer,          //its logical volume
	  logicbox,            //its mother
	  kXAxis,              //axis of replication
	  kDimX,               //number of replica
	  box_sizeX / kDimX);  // witdth of replica

  // Column Y
  G4Box* solidColumn =
	  new G4Box("Column", 0.5*box_sizeX/kDimX, 0.5*box_sizeY/kDimY, 0.5*box_sizeZ);

  G4LogicalVolume* logicColumn =
	  new G4LogicalVolume(solidColumn, Seawater, "ColumnLV");

  new G4PVReplica(
	  "Column",             //its name
	  logicColumn,          //its logical volume
	  logicLayer,            //its mother
	  kYAxis,              //axis of replication
	  kDimY,               //number of replica
	  box_sizeY / kDimY);  // witdth of replica

  // Cell Z
  G4Box* solidCell =
	  new G4Box("Cell", 0.5*box_sizeX/kDimX, 0.5*box_sizeY/kDimY, 0.5*box_sizeZ/kDimY);

  G4LogicalVolume* logicCell =
	  new G4LogicalVolume(solidCell, Seawater, "CellLV");

  new G4PVReplica(
	  "Cell",                  //its name
	  logicCell,               //its logical volume
	  logicColumn,             //its mother
	  kZAxis,                  //axis of replication
	  kDimZ,                   //number of replica
	  box_sizeZ / kDimZ);      // witdth of replica


  // sensitive detector
  G4Orb* solidDet =
	  new G4Orb("Det", det_radius);

  flogicDet =
	  new G4LogicalVolume(solidDet, Seawater, "DetLV");

  new G4PVPlacement(0,            //no rotation
	  G4ThreeVector(),            //at (0,0,0)
	  flogicDet,                  //its logical volume
	  "Det",                      //its name
	  logicCell,                  //its mother  volume
	  false,                      //no boolean operation
	  0,                          //copy number
	  checkOverlaps);             //overlaps checking



  // visualization attributes 

  auto visAttributes = new G4VisAttributes(G4Colour(1.0, 1.0, 1.0));
  visAttributes->SetVisibility(false);
  logicCell->SetVisAttributes(visAttributes);
  logicColumn->SetVisAttributes(visAttributes);
  logicLayer->SetVisAttributes(visAttributes);
  visAttributes = new G4VisAttributes(G4Colour(0.5, 0.5, 0.5)); // LightGray
  flogicDet->SetVisAttributes(visAttributes);

  return physWorld;
}

///////////////////////////////////////////////////////////////////////////////

void DetectorConstruction::ConstructSDandField()
{
	// 
	// Sensitive detectors
	//
	auto SDManager = G4SDManager::GetSDMpointer();
	G4String SDname;

	auto PMTSD1 = new PMTSD(SDname = "/PMT");
	SDManager->AddNewDetector(PMTSD1);
	flogicDet->SetSensitiveDetector(PMTSD1);

	// Add optical photon filter
	G4SDParticleFilter* OpPhotonFilter =
		new G4SDParticleFilter("OpPhotonFilter", "opticalphoton");
	PMTSD1->SetFilter(OpPhotonFilter);
	
}

///////////////////////////////////////////////////////////////////////////////
