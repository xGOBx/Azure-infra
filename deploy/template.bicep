param servers_devxserverdb_name string = 'devxserverdbx'
param sites_DevExchangeClient_name string = 'DevExchangeClientx'
param sites_DevExchangeServer_name string = 'DevExchangeServerx'
param storageAccounts_devexchangevault_name string = 'devexchangevaultx'
param serverfarms_ASP_DevExchangeServerResourceGroup_a54c_name string = 'ASP-DevExchangeServerResourceGroup-a54c'
param emailServices_DevExchangeEmailServiceSender_name string = 'DevExchangeEmailServiceSenderx'
param CommunicationServices_DevExchangeEmailService_name string = 'DevExchangeEmailServicex'

@description('Enter the database Password')
@secure()
param administratorLoginPassword string

@description('Subscription ID for resources')
param subscriptionId string = 'a14a797b-7111-4a43-a0e1-4158d93a478f'

var storageBaseUrl = 'https://${storageAccounts_devexchangevault_name}.blob.core.windows.net'

resource emailServices_DevExchangeEmailServiceSender_name_resource 'Microsoft.Communication/emailServices@2023-06-01-preview' = {
  name: emailServices_DevExchangeEmailServiceSender_name
  location: 'global'
  properties: {
    dataLocation: 'United States'
  }
}




resource servers_devxserverdb_name_resource 'Microsoft.Sql/servers@2024-05-01-preview' = {
  name: servers_devxserverdb_name
  location: 'eastus2'
  kind: 'v12.0'
  properties: {
    administratorLogin: 'Invincible'
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
    minimalTlsVersion: 'None'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource storageAccounts_devexchangevault_name_resource 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccounts_devexchangevault_name
  location: 'canadacentral'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource serverfarms_ASP_DevExchangeServerResourceGroup_a54c_name_resource 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: serverfarms_ASP_DevExchangeServerResourceGroup_a54c_name
  location: 'Canada Central'
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 0
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 0
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource CommunicationServices_DevExchangeEmailService_name_resource 'Microsoft.Communication/CommunicationServices@2023-06-01-preview' = {
  name: CommunicationServices_DevExchangeEmailService_name
  location: 'global'
  properties: {
    dataLocation: 'United States'
    linkedDomains: [
      emailServices_DevExchangeEmailServiceSender_name_AzureManagedDomain.id
    ]
  }
}

resource emailServices_DevExchangeEmailServiceSender_name_AzureManagedDomain 'Microsoft.Communication/emailServices/domains@2023-06-01-preview' = {
  parent: emailServices_DevExchangeEmailServiceSender_name_resource
  name: 'AzureManagedDomain'
  location: 'global'
  properties: {
    domainManagement: 'AzureManaged'
    userEngagementTracking: 'Disabled'
  }
}



resource servers_devxserverdb_name_Default 'Microsoft.Sql/servers/advancedThreatProtectionSettings@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

resource servers_devxserverdb_name_CreateIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_resource
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_devxserverdb_name_DbParameterization 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_resource
  name: 'DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_devxserverdb_name_DefragmentIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_resource
  name: 'DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_devxserverdb_name_DropIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_resource
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_devxserverdb_name_ForceLastGoodPlan 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_resource
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
}

resource Microsoft_Sql_servers_auditingPolicies_servers_devxserverdb_name_Default 'Microsoft.Sql/servers/auditingPolicies@2014-04-01' = {
  parent: servers_devxserverdb_name_resource
  name: 'Default'
  location: 'East US 2'
  properties: {
    auditingState: 'Disabled'
  }
}

resource Microsoft_Sql_servers_auditingSettings_servers_devxserverdb_name_Default 'Microsoft.Sql/servers/auditingSettings@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource Microsoft_Sql_servers_connectionPolicies_servers_devxserverdb_name_default 'Microsoft.Sql/servers/connectionPolicies@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'default'
  location: 'eastus2'
  properties: {
    connectionType: 'Default'
  }
}

resource servers_devxserverdb_name_DevExchange_Server_db 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'DevExchange.Server_db'
  location: 'eastus2'
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 10
  }
  kind: 'v12.0,user'
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Geo'
    maintenanceConfigurationId: '/subscriptions/${subscriptionId}/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/SQL_Default'
    isLedgerOn: false
    availabilityZone: 'NoPreference'
  }
}

resource servers_devxserverdb_name_DevExchangeDatabase 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'DevExchangeDatabase'
  location: 'eastus2'
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 5
  }
  kind: 'v12.0,user'
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Geo'
    maintenanceConfigurationId: '/subscriptions/${subscriptionId}/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/SQL_Default'
    isLedgerOn: false
    availabilityZone: 'NoPreference'
  }
}

resource servers_devxserverdb_name_master_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2024-05-01-preview' = {
  name: '${servers_devxserverdb_name}/master/Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_devxserverdb_name_master_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  name: '${servers_devxserverdb_name}/master/Default'
  location: 'East US 2'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_devxserverdb_name_master_Default 'Microsoft.Sql/servers/databases/auditingSettings@2024-05-01-preview' = {
  name: '${servers_devxserverdb_name}/master/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_devxserverdb_name_master_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2024-05-01-preview' = {
  name: '${servers_devxserverdb_name}/master/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_devxserverdb_name_master_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2024-05-01-preview' = {
  name: '${servers_devxserverdb_name}/master/Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_master_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2024-05-01-preview' = {
  name: '${servers_devxserverdb_name}/master/Current'
  properties: {}
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_devxserverdb_name_master_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2024-05-01-preview' = {
  name: '${servers_devxserverdb_name}/master/Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_devxserverdb_name_master_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2024-05-01-preview' = {
  name: '${servers_devxserverdb_name}/master/Current'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_devxserverdb_name_master_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2024-05-01-preview' = {
  name: '${servers_devxserverdb_name}/master/Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_devOpsAuditingSettings_servers_devxserverdb_name_Default 'Microsoft.Sql/servers/devOpsAuditingSettings@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'Default'
  properties: {
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_devxserverdb_name_current 'Microsoft.Sql/servers/encryptionProtector@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'current'
  kind: 'servicemanaged'
  properties: {
    serverKeyName: 'ServiceManaged'
    serverKeyType: 'ServiceManaged'
    autoRotationEnabled: false
  }
}

resource Microsoft_Sql_servers_extendedAuditingSettings_servers_devxserverdb_name_Default 'Microsoft.Sql/servers/extendedAuditingSettings@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_devxserverdb_name_AllowAllAzureIPs 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'AllowAllAzureIPs'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource servers_devxserverdb_name_ClientIPAddress_2025_02_09_08_43_48 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'ClientIPAddress_2025-02-09_08:43:48'
  properties: {
    startIpAddress: '104.222.17.242'
    endIpAddress: '104.222.17.242'
  }
}

resource servers_devxserverdb_name_ClientIPAddress_2025_02_11_04_53_07 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'ClientIPAddress_2025-02-11_04:53:07'
  properties: {
    startIpAddress: '160.10.198.137'
    endIpAddress: '160.10.198.137'
  }
}

resource servers_devxserverdb_name_ClientIPAddress_2025_02_25_03_19_56 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'ClientIPAddress_2025-02-25_03:19:56'
  properties: {
    startIpAddress: '160.10.196.12'
    endIpAddress: '160.10.196.12'
  }
}

resource servers_devxserverdb_name_ClientIPAddress_2025_02_27_04_37_02 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'ClientIPAddress_2025-02-27_04:37:02'
  properties: {
    startIpAddress: '160.10.199.212'
    endIpAddress: '160.10.199.212'
  }
}

resource servers_devxserverdb_name_query_editor_16541e 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'query-editor-16541e'
  properties: {
    startIpAddress: '160.10.197.99'
    endIpAddress: '160.10.197.99'
  }
}

resource servers_devxserverdb_name_query_editor_211f79 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'query-editor-211f79'
  properties: {
    startIpAddress: '160.10.198.188'
    endIpAddress: '160.10.198.188'
  }
}

resource servers_devxserverdb_name_query_editor_7eb1c1 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'query-editor-7eb1c1'
  properties: {
    startIpAddress: '160.10.197.93'
    endIpAddress: '160.10.197.93'
  }
}

resource servers_devxserverdb_name_query_editor_9f18ff 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'query-editor-9f18ff'
  properties: {
    startIpAddress: '160.10.197.166'
    endIpAddress: '160.10.197.166'
  }
}

resource servers_devxserverdb_name_query_editor_d3815f 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'query-editor-d3815f'
  properties: {
    startIpAddress: '160.10.199.188'
    endIpAddress: '160.10.199.188'
  }
}

resource servers_devxserverdb_name_query_editor_e01e75 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'query-editor-e01e75'
  properties: {
    startIpAddress: '160.10.196.43'
    endIpAddress: '160.10.196.43'
  }
}

resource servers_devxserverdb_name_ServiceManaged 'Microsoft.Sql/servers/keys@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'ServiceManaged'
  kind: 'servicemanaged'
  properties: {
    serverKeyType: 'ServiceManaged'
  }
}

resource Microsoft_Sql_servers_securityAlertPolicies_servers_devxserverdb_name_Default 'Microsoft.Sql/servers/securityAlertPolicies@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
}

resource storageAccounts_devexchangevault_name_default 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccounts_devexchangevault_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_devexchangevault_name_default 'Microsoft.Storage/storageAccounts/fileServices@2023-05-01' = {
  parent: storageAccounts_devexchangevault_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_devexchangevault_name_default 'Microsoft.Storage/storageAccounts/queueServices@2023-05-01' = {
  parent: storageAccounts_devexchangevault_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_devexchangevault_name_default 'Microsoft.Storage/storageAccounts/tableServices@2023-05-01' = {
  parent: storageAccounts_devexchangevault_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource sites_DevExchangeClient_name_resource 'Microsoft.Web/sites@2024-04-01' = {
  name: sites_DevExchangeClient_name
  location: 'Canada Central'
  tags: {
  
  }
  kind: 'app'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_DevExchangeClient_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_DevExchangeClient_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_DevExchangeServerResourceGroup_a54c_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    ipMode: 'IPv4'
    vnetBackupRestoreEnabled: false
    customDomainVerificationId: 'C4AAAF9A4418B7F1CEC0DE0F9C0CD1C4904936C55D5C70C87A320F97D2A72F04'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    endToEndEncryptionEnabled: false
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
    autoGeneratedDomainNameLabelScope: 'TenantReuse'
  }
}

resource sites_DevExchangeServer_name_resource 'Microsoft.Web/sites@2024-04-01' = {
  name: sites_DevExchangeServer_name
  location: 'Canada Central'
  tags: {
    'hidden-related:/subscriptions/${subscriptionId}/resourceGroups/DevExchangeServerResourceGroup/providers/Microsoft.Web/serverFarms/ASP-DevExchangeServerResourceGroup-a54c': 'empty'
  }
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_DevExchangeServer_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_DevExchangeServer_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_DevExchangeServerResourceGroup_a54c_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 1
      connectionStrings: [
        {
          name: 'DefaultConnection'
          connectionString: 'Data Source=${servers_devxserverdb_name}.database.windows.net,1433;Initial Catalog=DevExchangeDatabase;User ID=Invincible;Password=${administratorLoginPassword}'
          type: 'SQLAzure'
        }
      ]
      appSettings: [
        {
          name: 'AzureCommunicationServices__ConnectionString'
          value: 'endpoint=https://${CommunicationServices_DevExchangeEmailService_name}.unitedstates.communication.azure.com/;accesskey=${listKeys(CommunicationServices_DevExchangeEmailService_name_resource.id,'2023-06-01-preview').primaryKey}'
          slotSetting: true
        }
        {
          name: 'AzureCommunicationServices__SenderEmail'
          value: 'donotreply@${reference(emailServices_DevExchangeEmailServiceSender_name_AzureManagedDomain.id,'2023-06-01-preview').mailFromSenderDomain}'
          slotSetting: true
        }
        {
          name: 'AzureStorage__AccountKey'
          value: listKeys(storageAccounts_devexchangevault_name_resource.id, '2023-05-01').keys[0].value
          slotSetting: true
        }
        {
          name: 'AzureStorage__AccountName'
          value: storageAccounts_devexchangevault_name
          slotSetting: true
        }
        {
          name: 'AzureStorage__BaseUrl'
          value: storageBaseUrl
          slotSetting: true
        }
        {
          name: 'AzureStorage__ConnectionString'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccounts_devexchangevault_name};AccountKey=${listKeys(storageAccounts_devexchangevault_name_resource.id,'2023-05-01').keys[0].value};EndpointSuffix=core.windows.net'
          slotSetting: true
        }
        {
          name: 'Cors:ProductionOrigins'
          value: '["https://${toLower(sites_DevExchangeServer_name)}.azurewebsites.net","https://${sites_DevExchangeClient_name_resource.properties.defaultHostName}","${storageBaseUrl}"]'
          slotSetting: true
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '6.9.1'
          slotSetting: false
        }
        {
          name: 'WEB_URL'
          value: 'https://${sites_DevExchangeClient_name_resource.properties.defaultHostName}'
          slotSetting: true
        }
      ]
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    ipMode: 'IPv4'
    vnetBackupRestoreEnabled: false
    customDomainVerificationId: 'C4AAAF9A4418B7F1CEC0DE0F9C0CD1C4904936C55D5C70C87A320F97D2A72F04'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    endToEndEncryptionEnabled: false
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_DevExchangeClient_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: sites_DevExchangeClient_name_resource
  name: 'ftp'
  location: 'Canada Central'
  tags: {
  }
  properties: {
    allow: false
  }
}

resource sites_DevExchangeServer_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: sites_DevExchangeServer_name_resource
  name: 'ftp'
  location: 'Canada Central'
  tags: {
    'hidden-related:/subscriptions/${subscriptionId}/resourceGroups/DevExchangeServerResourceGroup/providers/Microsoft.Web/serverFarms/ASP-DevExchangeServerResourceGroup-a54c': 'empty'
  }
  properties: {
    allow: true
  }
}

resource sites_DevExchangeClient_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: sites_DevExchangeClient_name_resource
  name: 'scm'
  location: 'Canada Central'
  tags: {
  }
  properties: {
    allow: false
  }
}

resource sites_DevExchangeServer_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: sites_DevExchangeServer_name_resource
  name: 'scm'
  location: 'Canada Central'
  tags: {
    'hidden-related:/subscriptions/${subscriptionId}/resourceGroups/DevExchangeServerResourceGroup/providers/Microsoft.Web/serverFarms/ASP-DevExchangeServerResourceGroup-a54c': 'empty'
  }
  properties: {
    allow: true
  }
}

resource sites_DevExchangeServer_name_web 'Microsoft.Web/sites/config@2024-04-01' = {
  parent: sites_DevExchangeServer_name_resource
  name: 'web'
  location: 'Canada Central'
  tags: {
    'hidden-related:/subscriptions/${subscriptionId}/resourceGroups/DevExchangeServerResourceGroup/providers/Microsoft.Web/serverFarms/ASP-DevExchangeServerResourceGroup-a54c': 'empty'
  }
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v6.0'
    phpVersion: '5.6'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2022'
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$DevExchangeServer'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    cors: {
      allowedOrigins: [
        'https://${sites_DevExchangeClient_name_resource.properties.defaultHostName}'
      ]
      supportCredentials: true
    }
    localMySqlEnabled: false
    managedServiceIdentityId: 79235
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 1
    azureStorageAccounts: {}
  }
}

resource sites_DevExchangeServer_name_sites_DevExchangeServer_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2024-04-01' = {
  parent: sites_DevExchangeServer_name_resource
  name: '${sites_DevExchangeServer_name}.azurewebsites.net'
  location: 'Canada Central'
  properties: {
    siteName: sites_DevExchangeServer_name
    hostNameType: 'Verified'
  }
}

resource sites_DevExchangeServer_name_Microsoft_AspNetCore_AzureAppServices_SiteExtension 'Microsoft.Web/sites/siteextensions@2024-04-01' = {
  parent: sites_DevExchangeServer_name_resource
  name: 'Microsoft.AspNetCore.AzureAppServices.SiteExtension'
  location: 'Canada Central'
}

resource emailServices_DevExchangeEmailServiceSender_name_azuremanageddomain_donotreply 'microsoft.communication/emailservices/domains/senderusernames@2023-06-01-preview' = {
  name: '${emailServices_DevExchangeEmailServiceSender_name}/azuremanageddomain/donotreply'
  properties: {
    username: 'DoNotReply'
    displayName: 'DoNotReply'
  }
  dependsOn: [
    emailServices_DevExchangeEmailServiceSender_name_AzureManagedDomain
    emailServices_DevExchangeEmailServiceSender_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchange_Server_db_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchangeDatabase_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchange_Server_db_CreateIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchangeDatabase_CreateIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchange_Server_db_DbParameterization 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchangeDatabase_DbParameterization 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchange_Server_db_DefragmentIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchangeDatabase_DefragmentIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchange_Server_db_DropIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchangeDatabase_DropIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchange_Server_db_ForceLastGoodPlan 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchangeDatabase_ForceLastGoodPlan 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_devxserverdb_name_DevExchange_Server_db_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'Default'
  location: 'East US 2'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_devxserverdb_name_DevExchangeDatabase_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'Default'
  location: 'East US 2'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_devxserverdb_name_DevExchange_Server_db_Default 'Microsoft.Sql/servers/databases/auditingSettings@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_devxserverdb_name_DevExchangeDatabase_Default 'Microsoft.Sql/servers/databases/auditingSettings@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupLongTermRetentionPolicies_servers_devxserverdb_name_DevExchange_Server_db_default 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'default'
  properties: {
    weeklyRetention: 'PT0S'
    monthlyRetention: 'PT0S'
    yearlyRetention: 'PT0S'
    weekOfYear: 0
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupLongTermRetentionPolicies_servers_devxserverdb_name_DevExchangeDatabase_default 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'default'
  properties: {
    weeklyRetention: 'PT0S'
    monthlyRetention: 'PT0S'
    yearlyRetention: 'PT0S'
    weekOfYear: 0
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupShortTermRetentionPolicies_servers_devxserverdb_name_DevExchange_Server_db_default 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'default'
  properties: {
    retentionDays: 7
    diffBackupIntervalInHours: 24
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupShortTermRetentionPolicies_servers_devxserverdb_name_DevExchangeDatabase_default 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'default'
  properties: {
    retentionDays: 7
    diffBackupIntervalInHours: 24
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_devxserverdb_name_DevExchange_Server_db_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_devxserverdb_name_DevExchangeDatabase_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_devxserverdb_name_DevExchange_Server_db_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'Default'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_devxserverdb_name_DevExchangeDatabase_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'Default'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchange_Server_db_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'Current'
  properties: {}
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource servers_devxserverdb_name_DevExchangeDatabase_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'Current'
  properties: {}
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_devxserverdb_name_DevExchange_Server_db_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_devxserverdb_name_DevExchangeDatabase_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_devxserverdb_name_DevExchange_Server_db_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'Current'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_devxserverdb_name_DevExchangeDatabase_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'Current'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_devxserverdb_name_DevExchange_Server_db_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchange_Server_db
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_devxserverdb_name_DevExchangeDatabase_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2024-05-01-preview' = {
  parent: servers_devxserverdb_name_DevExchangeDatabase
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_devxserverdb_name_resource
  ]
}

resource storageAccounts_devexchangevault_name_default_cats 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: storageAccounts_devexchangevault_name_default
  name: 'cats'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_devexchangevault_name_resource
  ]
}

resource storageAccounts_devexchangevault_name_default_toads 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: storageAccounts_devexchangevault_name_default
  name: 'toads'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_devexchangevault_name_resource
  ]
}

resource storageAccounts_devexchangevault_name_default_website_banners 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: storageAccounts_devexchangevault_name_default
  name: 'website-banners'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_devexchangevault_name_resource
  ]
}
