###TODO Filter on just WCC to export

require 'date'

class WCC_DRN_Exporter
	def WCC_DRN_Exporter.OnFilterRecordPipe(obj)
		return obj['status']!='REMO'
	end
	def WCC_DRN_Exporter.OnFilterRecordValve(obj)
		return obj['status']!='REMO'
	end
	def WCC_DRN_Exporter.OnFilterRecordAllNodes(obj)
		return obj['status']!='REMO'
	end
	def WCC_DRN_Exporter.OnFilterRecordNode(obj)
		return obj['status']!='REMO'
	end
	def WCC_DRN_Exporter.OnFilterRecordChannel(obj)
		return obj['status']!='REMO'
	end

###### General Attributes
  
	def WCC_DRN_Exporter.status(obj)
    transforms = {
      'INUS' => 'In Use',
      'ABAN' => 'Abandoned',
      'REMO' => 'Removed',
      'NA' => 'No Code Allocated',
      'PROP' => 'Proposed',
      'UNK' => 'Unknown',
      'NOFO' => 'Not Found',
      'VIRT' => 'Virtual Pipe-for virtual connectivity thru water bodies', ##TODO This needs to change
      'INPS' => 'Inside Pump Station & In Use'
      }
    if transforms.key?(obj['status'])
      return transforms.fetch(obj['status'])
    else
      return obj['status']
    end
	end
	
  def WCC_DRN_Exporter.owner(obj)
    transforms = {
      'WCC' => 'Wellington City Council',
      'PVT' => 'Private',
      'GWRC' => 'Greater Wellington Regional Council',
      'HCC' => 'Hutt City Council',
      'PCC' => 'Porirua City Council',
      'NZTA' => 'NZ Transport Agency',
      'NA' => 'No Code Allocated',
      'UNK' => 'Unknown',
      'WWL' => 'Wellington Waterfront Ltd'
      }
    if transforms.key?(obj['owner'])
      return transforms.fetch(obj['owner'])
    else
      return obj['owner']
    end
	end

###### Node Attributes  

	def WCC_DRN_Exporter.node_type(obj)
    transforms = {
      'SMH4' => 'WW Manhole',
      'SNT4' => 'WW Junction',
      'SLH4' => 'WW Lamphole',
      'SCH4' => 'WW Chamber',
      'SCH1' => 'WW Chamber Grit',
      'SCH2' => 'WW Chamber Balancing',
      'SCH3' => 'WW Chamber Large',
      'SOVF' => 'WW Overflow Outlet',
      'F' => 'WW Outfall',
      'SPS1' => 'WW Pump Station Wet Well',
      'SPS2' => 'WW Pump Station Dry Well',
      'S' => 'WW Soakpit',
      'I' => 'WW Inlet',
      'SVP1' => 'WW Vent Column',
      'STP1' => 'WW Treatment Plant',
      'SNT1' => 'WW Change of Direction',
      'SNT2' => 'WW Change of Grade',
      'SNT3' => 'WW Change of Pipe Type',
      'SNT6' => 'WW Dead End',
      'SNT7' => 'WW Unknown Node',
      'SNVC' => 'Valve Connection',
      'DMH4' => 'SW Manhole',
      'DLH4' => 'SW Lamphole',
      'DCH4' => 'SW Chamber',
      'DCH1' => 'SW Grit Chamber',
      'DNT1' => 'SW Change of Direction',
      'DNT2' => 'SW Change of Grade',
      'DNT3' => 'SW Change of Pipe Type',
      'DNT4' => 'SW Junction',
      'DNT6' => 'SW Dead End',
      'DNT7' => 'SW Unknown Node',
      'DNT8' => 'SW Valve Connection',
      'DSTR' => 'SW Stream Junction',
      'SOVI' => 'SW Overflow Inlet',
      'DPS1' => 'SW Wet well',
      'DOVF' => 'SW Overflow Outlet',
      'DIL1' => 'SW Inlet Mushroom',
      'DIL2' => 'SW Inlet Open',
      'DIL3' => 'SW Inlet sump',
      'DIL4' => 'SW Inlet Gridded',
      'DIL5' => 'SW Inlet Double Sump',
      'DIL6' => 'SW Inlet Super sump',
      'DOL1' => 'SW Outlet Gridded',
      'DOL2' => 'SW Outlet open',
      'DOL3' => 'SW Outlet Drowned',
      'DOL4' => 'SW Outlet Dissipation',
      'DOUT' => 'Watercourse Mouth'
     }
    if transforms.key?(obj['node_type'])
      return transforms.fetch(obj['node_type'])
    else
      return obj['node_type']
		end
	end

	def WCC_DRN_Exporter.chamber_shape(obj)
    transforms = {
      'CIRC' => 'Circular',
      'RECT' => 'Rectangle',
      'OVD' => 'Ovoid',
      'OVDA' => 'Ovoid A',
      'OVDB' => 'Ovoid B',
      'TREZ' => 'Trapezoidal',
      'TRIA' => 'Trapezoidal',
      'SLH4' => 'Sewer Lamp Hole',
      'SNT1' => 'Change Direction',
      'SMH4' => 'Manhole',
      'SWBB' => 'Bubble Box',
      'SWC' => 'Circular Sump',
      'SWGC' => 'Greek Chamber',
      'SWHB' => 'Half Box',
      'SWRB' => 'Rectangular Box',
      'SWSS' => 'Standard Single',
      'VP1' => 'Sewer Vent Pipe',
      'NA' => 'No code allocated'
      }
    if transforms.key?(obj['chamber_shape'])
      return transforms.fetch(obj['chamber_shape'])
    else
      return obj['chamber_shape']
		end
	end
  
	def WCC_DRN_Exporter.chamber_construction(obj)
    transforms = {
      'BR' => 'Brick',
      'RCP' => 'Reinforced Concrete Precast Unit',
      'RCI' => 'Reinforced Concrete In-Situ',
      'CONC' => 'Concrete',
      'CI' => 'Cast Iron',
      'NA' => 'No code allocated'
     }
    if transforms.key?(obj['chamber_construction'])
      return transforms.fetch(obj['chamber_construction'])
    else
      return obj['chamber_construction']
		end
	end

	def WCC_DRN_Exporter.cover_material(obj)
    transforms = {
		 'CO'	=> 'Concrete',
		 'GA'	=> 'Steel-Gatic',
		 'GR'	=> 'Grate',
		 'ST'	=> 'Steel',
		 'O' => 'Other'
     }
    if transforms.key?(obj['cover_material'])
      return transforms.fetch(obj['cover_material'])
    else
      return obj['cover_material']
		end
	end
  
###### Pipe Attributes  

	def WCC_DRN_Exporter.pipe_type(obj)
    transforms = {
      'WWMN' => 'WW Main',
      'WWRM' => 'WW Rising Main',
      'WWIN' => 'WW Interceptor',
      'WWTR' => 'WW Trunk Main',
      'WWOV' => 'WW Overflow',
      'WWSY' => 'WW Syphon',
      'WWLA' => 'WW Lateral',
      'DPI1' => 'SW Pipe',
      'DPI2' => 'SW Syphon',
      'DPI3' => 'SW Culvert',
      'DPI4' => 'SW Channel',
      'DPI5' => 'SW Flume',
      'DPI6' => 'SW Tunnel',
      'DPI7' => 'SW Overflow',
      'DPI8' => 'SW Sump Lead',
      'DPI9' => 'SW Unknown',
      'DPI10' => 'SW Pressure Main',
      'DOVF' => 'Overflow',
      'DFD1' => 'Field Drain',
      'STRU' => 'Struct Protection'
     }
    if transforms.key?(obj['pipe_type'])
      return transforms.fetch(obj['pipe_type'])
    else
      return obj['pipe_type']
		end
	end
  
	def WCC_DRN_Exporter.height(obj) 
		if obj['height'] = '' 
			return obj['height'] == '0'
		else
			return obj['height']
		end
	end

	def WCC_DRN_Exporter.pipe_material(obj)
    transforms = {
      'AC' => 'Asbestos Cement',
      'BR' => 'Brick',
      'CI' => 'Cast Iron',
      'CONC' => 'Concrete',
      'EARE' => 'Earthenware',
      'DI' => 'Ductile Iron',
      'DICL' => 'Ductile Iron-cement lined',
      'GRP' => 'Glass Reinforced Plastic',
      'PE' => 'Polyethylene',
      'ST' => 'Steel',
      'ACET' => 'AC-Eternite',
      'ACEV' => 'AC-Everite',
      'ACFI' => 'AC-Fibrolite',
      'ACIT' => 'AC-Italite',
      'ALU' => 'Aluflo',
      'CIST' => 'Cast Iron-Staverley',
      'CE' => 'Ceramic',
      'CU' => 'Copper',
      'CAL' => 'Corrugated Aluminium',
      'CSUL' => 'Corrugated Steel',
      'GALS' => 'Galvanised Steel',
      'HDPE' => 'High Density Polyethylene',
      'HPPE' => 'High Pressure Polyethylene',
      'MDPE' => 'Medium Density Polyethylene',
      'MPVC' => 'mPVC',
      'P100' => 'PE100',
      'P80B' => 'PE80B',
      'PITF' => 'Pitch Fibre',
      'STEL' => 'Steel-epoxy lined',
      'PVC' => 'Polyvinyl Chloride',
      'PVCB' => 'PVC-Blue Brute',
      'RCON' => 'Reinforced Concrete',
      'RHR' => 'Rough hewn rock-unlined',
      'STON' => 'Stoneware',
      'UPVC' => 'uPVC',
      'STCL' => 'Steel-cement lined',
      'STS' => 'Steel-spiral weld',
      'GI' => 'Galvanised Iron',
      'NA' => 'No code allocated'
     }
    if transforms.key?(obj['pipe_material'])
      return transforms.fetch(obj['pipe_material'])
    else
      return obj['pipe_material']
		end
	end

	def WCC_DRN_Exporter.lining_material(obj)
    transforms = {
      'Ak' =>	'Alkathene',
      'BITU' =>	'Bitumen (Lining)',
      'BR' =>	'Brick',
      'CEMM' =>	'Cement Mortar (Lining)',
      'EPOX' =>	'Epoxy',
      'GRP' => 'Glass Reinforced Plastic',
      'PE' =>	'Polyethylene',
      'PF' => 'Pitch Fiber',
      'PVC'=>	'Polyvinyl Chloride',
      'CIPP' =>	'CIPP Lining',
      'COAL' =>	'Coal Tar',
      'CONC' => 'Concrete',
      'ENAM' =>	'Enamel',
      'HDPE' =>	'High Density Polyethylene',
      'NA' => 'No Code Allocated'
     }
    if transforms.key?(obj['lining_material'])
      return transforms.fetch(obj['lining_material'])
    else
      return obj['lining_material']
		end
	end

  def WCC_DRN_Exporter.lining_type(obj)
    transforms = {
      'M'	=> 'Inserted During Manufacture',
      'SP' => 'Sprayed',
      'CIP' => 'Cured in Place',
      'SEG' => 'Segmental',
      'DP' => 'Lining with Discrete Pipes',
      'CP' => 'Lining with Continuous Pipes',
      'CF' => 'Close Fit Lining',
      'SW' => 'Spirally Wound Lining',
      'Z'	=> 'Other'
     }
    if transforms.key?(obj['lining_type'])
      return transforms.fetch(obj['lining_type'])
    else
      return obj['lining_type']
		end
	end

	def WCC_DRN_Exporter.shape(obj)
    transforms = {
      'CP' => 'Circular',
      'RB' => 'Rectangular Box',
      'OVD' => 'Ovoid',
      'OVDA' => 'Ovoid A',
      'OVDB' => 'Ovoid B',
      'ES' => 'Egg-Shaped',
      'H' => 'Horseshoe',
      'SB' => 'Square Box',
      'TR' => 'Trapezoidal',
      'US' => 'U-Shaped'
     }
    if transforms.key?(obj['shape'])
      return transforms.fetch(obj['shape'])
    else
      return obj['shape']
		end
	end

	def WCC_DRN_Exporter.user_text_7(obj)
    transforms = {
      'D' => 'Class D',
      'F' => 'Class F',
      'S' => 'Class S',
      'X' => 'Class X',
      'Y' => 'Class Y',
      'Z' => 'Class Z',
      'Z+' => 'Class Z+',
      'HD' => 'Class HD',
      'K9' => 'Class K9',
      '1611' => 'SDR11 - PN16',
      '1211' => 'SDR11 - PN12.5',
      'SD17' => 'SDR17',
      'SD22' => 'SDR22',
      '2106' => 'SDR26',
      'SD32' => 'SDR32',
      'SG' => 'Sewer Grade',
      'CE' => 'Ceramic',
      'UNK' => 'Unknown'
     }
    if transforms.key?(obj['user_text_7'])
      return transforms.fetch(obj['user_text_7'])
    else
      return obj['user_text_7']
		end
	end

	def WCC_DRN_Exporter.user_text_6(obj) #joint_type
    transforms = {
		 'BOLT' => 'Bolted',
		 'BUTT' => 'Butt',
		 'BWLD' => 'Butt Weld',
		 'COMP' => 'Cement Mortar',
		 'FJ' => 'Flush Joint',
		 'FUSN' => 'Fusion Weld',
		 'GIBT' => 'Gibault',
		 'GLUE' => 'Glued Joint',
		 'RR' => 'Rubber Ring Joint',
		 'RRZ' => 'Rubber Ring Joint (Z joint)',
		 'SLV' => 'Sleeve',
		 'SLVD' => 'Sleeve - Double Wire',
		 'SLVW' => 'Sleeve - Wired',
		 'STIT' => 'Supertite',
     'NA' => 'No Code Allocated'
     }
    if transforms.key?(obj['user_text_6'])
      return transforms.fetch(obj['user_text_6'])
    else
      return obj['user_text_6']
		end
	end

###### Other Attributes
  
	def WCC_DRN_Exporter.type(obj) #valve type
    transforms = {
      'SRM1' => 'Sewer-Rising Main Valve Air',
      'SRM2' => 'Sewer-Rising Main Valve BF',
      'SRM3' => 'Sewer-Rising Main Valve Gate',
      'SRM4' => 'Sewer-Rising Main Valve NR',
      'SRM5' => 'Sewer-Rising Main Valve Reflux',
      'SRM6' => 'Sewer-Rising Main Valve Sluice',
      'SRM7' => 'Sewer-Rising Main Shut Valve'
     }
    if transforms.key?(obj['type'])
      return transforms.fetch(obj['type'])
    else
      return obj['type']
		end
	end
end

class WCC_PW_Exporter
  # Filters out removed assets

	def WCC_PW_Exporter.OnFilterRecordPipe(obj)
		return obj['operational_status']!='REMO'# && obj['operational_status']!='ABAN'
	end
	def WCC_PW_Exporter.OnFilterRecordFitting(obj)
		return obj['operational_status']!='REMO'# && obj['operational_status']!='ABAN'
	end
	def WCC_PW_Exporter.OnFilterRecordHydrant(obj)
		return obj['operational_status']!='REMO'# && obj['operational_status']!='ABAN'
	end
	def WCC_PW_Exporter.OnFilterRecordMeter(obj)
		return obj['operational_status']!='REMO'# && obj['operational_status']!='ABAN'
	end
	def WCC_PW_Exporter.OnFilterRecordValve(obj)
		return obj['operational_status']!='REMO'# && obj['operational_status']!='ABAN'
	end	
	def WCC_PW_Exporter.OnFilterRecordPump(obj)
		return obj['operational_status']!='REMO'# && obj['operational_status']!='ABAN'
	end
	def WCC_PW_Exporter.OnFilterRecordTank(obj)
		return obj['operational_status']!='REMO'# && obj['operational_status']!='ABAN'
	end
	def WCC_PW_Exporter.OnFilterRecordPumpStation(obj)
		return obj['operational_status']!='REMO'# && obj['operational_status']!='ABAN'
	end	

# Turns codes into descriptions.
  def WCC_PW_Exporter.owner(obj)
    transforms = {
      'WCC' => 'Wellington City Council',
      'PVT' => 'Private',
      'GWRC' => 'Greater Wellington Regional Council',
      'HCC' => 'Hutt City Council',
      'PCC' => 'Porirua City Council',
      'NZTA' => 'NZ Transport Agency',
      'NA' => 'No Code Allocated',
      'UNK' => 'Unknown',
      'WWL' => 'Wellington Waterfront Ltd'
      }
    if transforms.key?(obj['owner'])
      return transforms.fetch(obj['owner'])
    else
      return obj['owner']
    end
	end

	def WCC_PW_Exporter.use(obj)
		if obj['use'] == 'SERV'
			return 'SERVICE'
		else
			return obj['use']
 		end
	end

	def WCC_PW_Exporter.user_text_11(obj)
		if obj['user_text_11'] == 'SERV'
			return 'SERVICE'
		else
			return obj['user_text_11']
 		end
	end

### TODO This doesn't appear to be in the config file--remove?
	def WCC_PW_Exporter.rehab_method(obj)
      transforms = {
        'SCOUR' => 'Air Scour',
        'PPIG' => 'Poly Pigging',
        'JET' => 'High Pressure Jetting',
        'DOWNSIZE' => 'Downsizing',
        'UPSIZE' => 'Upsizing',
        'AB' => 'Abandon',
        'UNK' => 'Unknown',
        'NA' => 'No Code Allocated'
      }
    if transforms.key?(obj['rehab_method'])
      return transforms.fetch(obj['rehab_method'])
    else
      return obj['rehab_method']
    end
	end

	def WCC_PW_Exporter.lining_material(obj)
      transforms = {
        'BITU' => 'Bitumen',
        'CEMM' => 'Cement Mortar',
        'EPOX' => 'Epoxy',
        'CONC' => 'Concrete',
        'ENAM' => 'Enamel',
        'TATE' => 'Tate'
        }
    if transforms.key?(obj['lining_material'])
      return transforms.fetch(obj['lining_material'])
		else
			return obj['lining_material']
 		end
	end
  
### TODO This doesn't appear in config file -- remove?
	def WCC_PW_Exporter.lining_type(obj)
      transforms = {
        'STRUC' => 'Structural',
        'NONSTRUC' => 'Non-Structural',
        'ROLL' => 'Rolldown',
        'CURED' => 'Cured in Situ',
        'NA' => 'No code allocated'
        }
    if transforms.key?(obj['lining_type'])
      return transforms.fetch(obj['lining_type'])
		else
			return obj['lining_type']
		end
	end

  ### TODO This doesn't appear in config file -- remove?
	def WCC_PW_Exporter.bedding_material(obj)
      transforms = {
        'CONC' => 'Concrete',
        'GRAN' => 'Granular',
        'NA' => 'No Code Allocated'
        }
    if transforms.key?(obj['bedding_material'])
      return transforms.fetch(obj['bedding_material'])
		else
			return obj['bedding_material']
 		end
	end

  ### fitting and pipe
	def WCC_PW_Exporter.joint_type(obj)
      transforms = {
        'FLANGE' => 'Flanged',
        'GIBT' => 'Gibault',
        'lead' => 'Lead',
        'FUSN' => 'Fusion Weld',
        'BOLT' => 'Rubber Bolt',
        'PUSH' => 'Rubber Push',
        'GLAND' => 'Screwed Gland',
        'SOLVENT' => 'Solvent Welded',
        'JVIK' => 'Johnson Viking',
        'WELD' => 'Welded Joint',
        'SOCK' => 'Socketed',
        'NA' => 'No Code Allocated',
        'RRJ' => 'Rubber Ring Joint',
        'SCRW' => 'Screwed',
        'RRTL' => 'Rubber Ring Tyton Lock',
        'NOJN' => 'No Join'
        }
    if transforms.key?(obj['joint_type'])
      return transforms.fetch(obj['joint_type'])
         	else
			return obj['joint_type']
 		end
	end

###TODO Add fitting material if necessary?  
	def WCC_PW_Exporter.material(obj)
      transforms = {
  #Pipe material
        'ACET' => 'AC - Eternite',
        'ACEV' => 'AC - Everite',
        'ACIT' => 'AC - Italite',
        'AC' => 'Asbestos Cement',
        'ACFI' => 'AC - Fibrolite',
        'CI' => 'Cast Iron',
        'CU' => 'Copper',
        'DICL' => 'Ductile Iron - Cement Lined',
        'DI' => 'Ductile Iron',
        'GI' => 'Galvanised Iron',
        'PE' => 'Polyethylene',
        'HDPE' => 'High Density Polyethylene',
        'MDPE' => 'Medium Density Polyethylene',
        'HPPE' => 'High Performance Polyethylene',
        'MPVC' => 'Modified Polyvinyl Chloride',
        'OPVC' => 'Oriented Polyvinyl Chloride',
        'PVC' => 'Polyvinyl Chloride',
        'PVCB' => 'PVC - Blue Brute',
        'SS' => 'Stainless Steel',
        'ST' => 'Steel',
        'STBL' => 'Steel - Bitumen Lined',
        'STCL' => 'Steel - Cement lined',
        'STEL' => 'Steel - Epoxy Lined',
        'STEN' => 'Steel - Enamel Lined',
        'STLB' => 'Steel Lock Bar',
        'STSW' => 'Steel - Spiral Weld',
        'UPVC' => 'Unplasticised Polyvinyl Chloride',
  #Reservoir material
        'CONC' => 'Concrete',
        'RCON' => 'Reinforced Concrete',
        'TIMB' => 'Timber'
        }
    if transforms.key?(obj['material'])
      return transforms.fetch(obj['material'])
		else
			return obj['material']
		end
	end
	
	def WCC_PW_Exporter.operational_status(obj)
      transforms = {
        'INUS' => 'In Use',
        'ABAN' => 'Abandoned',
        'REMO' => 'Removed',
        'VIRT' => 'VIRT'
        }
    if transforms.key?(obj['operational_status'])
      return transforms.fetch(obj['operational_status'])
		else
			return obj['operational_status']
		end
	end
	
	def WCC_PW_Exporter.type(obj)
      transforms = {
  #pipe type
        'FALL' => 'Falling Main',
        'FIRE' => 'Fire Service Pipe',
        'RIDE' => 'Rider Main',
        'RIFA' => 'Rising/Falling Main',
        'RISE' => 'Rising Main',
        'RETI' => 'Reticulation Main',
        'SCOU' => 'Scour Pipe',
        'SERV' => 'Customer Service Pipe',
        'TRNK' => 'Trunk Main',
        'STRU' => 'Struct Protection',
  #fitting type
        'BEND' => 'Bend Preformed',
        'BFP' => 'Back Flow Preventer',
        'CROS' => 'Cross',
        'END' => 'Dead End',
        'JOIN' => 'Joint',
        'REDU' => 'Reducer',
        'SPEC' => 'Special',
        'TAPB' => 'Tapping Band',
        'TEE' => 'Tee',
  #meter type
        'COMM' => 'Commercial',
        'RES' => 'Residential',
        'IND' => 'Industrial',
        'BULK' => 'Bulk Supply',
        'DMA' => 'District Meter Area',
  #reservoir type
        'RESV' => 'Reservoir',
        'PMT' => 'Pres Maintain Tank',
        'EMER' => 'Emergency Tank'
        }
    if transforms.key?(obj['type'])
      return transforms.fetch(obj['type'])
		else
			return obj['type']
	 	end
	end
	
	def WCC_PW_Exporter.mechanism(obj)
      transforms = {
  #valve mechanism      
        'AIRSNGL' => 'Air - Single',
        'AIRDBL' => 'Air - Double',
        'ALT' => 'Altitude',
        'BALL' => 'BALL',
        'CHCK' => 'Check',
        'CHCKSL' => 'Check - Spring Loaded',
        'DBLCHK' => 'Double Check',
        'DBLCHKSL' => 'Double Check Spring Loaded',
        'DIA' => 'Diaphragm',
        'FLAPCHK' => 'Flap Check',
        'FLOAT' => 'Float',
        'GATE' => 'Gate',
        'GLOBE' => 'Globe',
        'MANFLD' => 'Manifold',
        'ORIFCE' => 'Orifice',
        'REFLUX' => 'Reflux',
        'SLUICE' => 'Sluice',
  #meter mechanism
        'MECH' => 'Mechanical',
        'ELECT' => 'Electromagnetic',
        'TURBINE' => 'Turbine'      
        }
    if transforms.key?(obj['mechanism'])
      return transforms.fetch(obj['mechanism'])
		else
			return obj['mechanism']
 		end
	end	
	
	def WCC_PW_Exporter.system_type(obj)
      transforms = {
        #valve system type
        'FIRE' => 'Pipe - Fire Service',
        'PSINLET' => 'Pump Station - Inlet',
        'PSRISE' => 'Pump Station - Rising',
        'RETIC' => 'Pipe - Reticulation',
        'RIDER' => 'Pipe - Rider',
        'RSVRIN' => 'Reservoir - Inlet',
        'RESVROUT' => 'Reservoir Outlet',
        'RESVRSCR' => 'Reservoir - Scour',
        'SCOUR' => 'Pipe - Scour',
        'SERV' => 'Pipe - Service',
        'TRNK' => 'Pipe - Trunk'
        }
    if transforms.key?(obj['system_type'])
      return transforms.fetch(obj['system_type'])
		else
			return obj['system_type']
 		end	
 	end	
 	
 	def WCC_PW_Exporter.operational_role(obj)
      transforms = {
  #valve operational role
        'AIRIN' => 'Air In',
        'AIROUT' => 'Air Out',
        'AIRINOUT' => 'Air In and Out',
        'BDY' => 'Boundary Press. Zone',
        'CTRLFLOW' => 'Control - Flow',
        'CTRLPRESS' => 'Control - Pressure',
        'CTRLFLPR' => 'Control Flow and Press',
        'SERV' => 'Customer Service',
        'FIRE' => 'Fire Service',
        'PRESRELF' => 'Pressure Relief',
        'SCOUR' => 'Scour'
        }
    if transforms.key?(obj['operational_role'])
      return transforms.fetch(obj['operational_role'])
		else
			return obj['operational_role']
	 	end	
	 end	

	def WCC_PW_Exporter.status(obj)		#valve status
      transforms = {
        'OPEN' => 'Open',
        'SHUT' => 'Shut'
        }
    if transforms.key?(obj['status'])
      return transforms.fetch(obj['status'])
		else
			return obj['status']
	 	end			
 	end
 	
	def WCC_PW_Exporter.valve_control_type(obj)	#valve control type
      transforms = {
        'OPEN' => 'Open',
        'SHUT' => 'Shut',
        'AIR' => 'Air',
        'GEAR' => 'Gear Assembly',
        'GRAV' => 'Gravity Water Presure',
        'HYD' => 'Hydraulic',
        'MAN' => 'Manual',
        'PWR' => 'Power Supply',
        'PWRACT' => 'Power Supply and Actuator',
        'SEISMIC' => 'Seismic',
        'VALVWHEEL' => 'Valve Wheel',
        'VKEY' => 'Valve Key (Manual)',
        'VKEYEXT' => 'Valve Key and Extension Spindle (Manual)'
        }
    if transforms.key?(obj['valve_control_type'])
      return transforms.fetch(obj['valve_control_type'])
 		else
			return obj['valve_control_type']
	 	end
	end 
end
######

###  Declarations

# Point to an InfoNet database
d = DateTime.now
d.strftime("%Y-%m-%d")

db = WSApplication.open('10.249.30.6:40000/Infonet_PIMS',false)

# Specify ArcGIS license to associate with, might need to change to Server (default) eventually?                   															
WSApplication.use_arcgis_desktop_licence

#List of networks to export
networks = ['PW', 'WW', 'SW']

#Loop through network list and assign specific variables and export options
networks.each do |net|
  puts
  puts "Start InfoNet Export from #{net} masterdata network to WCC GIS CAPACITY"
  puts

  if net == 'WW'
    #Connects to WW network
    nw = db.model_object_from_type_and_id('Collection Network',8)
    #Sets the class (transforms) to use
    wcc_exporter = WCC_DRN_Exporter
    #Set feature dataset
    feature_dataset = 'Drainage' #net
    #Lists WW tables to export
    tables = {
      'pipe' => 'gis1_sde_drain_sewer_pipes',
      'node' => 'gis1_sde_drain_sewer_nodes',
      'pump' => 'WW_Pumps',
      'valve' => 'WW_Valves',
      'cctvsurvey' => 'CCTV_survey_WW'
      }
    #'pipe', 'node', 'connectionpipe', 'pump', 'pumpstation', 'storagearea', 'valve'
  elsif net == 'SW'
    nw = db.model_object_from_type_and_id('Collection Network',9)
    wcc_exporter = WCC_DRN_Exporter
    feature_dataset = 'Drainage'  #net 
    tables = {
      'pipe' => 'gis1_sde_drain_stormwater_pipes',
      'node' => 'gis1_sde_drain_stormwater_nodes',
      'channel' => 'drain_stormwater_channels',
#     'connectionpipe',
      'storagearea' => 'SW_Storage_Area',
      'cctvsurvey' => 'CCTV_survey_SW'
      }
  else
    nw = db.model_object_from_type_and_id('Distribution Network',1667)
    wcc_exporter = WCC_PW_Exporter
    feature_dataset = 'WCC-Water'
    tables = {
      'fitting' => 'W_Fitting',
      'hydrant' => 'W_Hydrants',
      'meter' => 'W_Meters',
      'pipe' => 'W_Pipes',
      'pump' => 'W_Pumps',
      'pumpstation' => 'W_Pumpstations',
      'tank' => 'W_Tanks',
      'valve' => 'W_Valves'
      }
  end
  
  # pull through network changes from others
  nw.update
  
  #Loop through the tables list, assign wcc_gdb_options and wcc_gdb_exportcfg and perform export.
  tables.each do |table, feature_class|
    wcc_gdb_options = {
      'Callback Class' => wcc_exporter,
      'Image Folder' => '',
      'Units Behaviour' => 'Native',
      'Report Mode' => false,
      'Export Selection' => false,
      'Previous Version' => 0,
      'Error File' => "G:\\Information Directorate\\InfoNet Scripting\\WCC\\ErrorLogs\\WCC_#{net}_#{table}_Exporterrorlog.txt"
      }
    print "Exporting InfoNet table '#{table}' to feature class '#{feature_class}' in GDB"
    begin
      nw.odec_export_ex(
        'GDB',
        "G:\\Information Directorate\\InfoNet Scripting\\WCC\\WCC Configuration Files\\WCC_Master_#{net}.cfg",  ### Make sure that the config file has the id assigned if updates are being made to existing GDB. {AssetID,False,False} for asset_id, {SourcePrimaryKey,True,False} for everything else
        wcc_gdb_options,
        table,
        feature_class,
        feature_dataset,
        false,
        nil,
        "G:\\Information Directorate\\InfoNet Scripting\\WCC\\WCC_TEMP.gdb"
  #      'C:\Users\ahuizenga\AppData\Roaming\ESRI\Desktop10.1\ArcCatalog\DEV_WCC.sde'
        )
    rescue
      puts "EXPORTED WITH ERRORS"
    else
      print '-Done'
    end
    puts
  end  
end