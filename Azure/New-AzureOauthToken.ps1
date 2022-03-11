<#
.SYNOPSIS
Get oauth token for azure and graph

.DESCRIPTION
Function will return OAuth token for Microsoft Azure and Microsoft Graph

.PARAMETER ClientID
Insert Microsoft Azure application ID

.PARAMETER ClientSecret
Insert Microsoft Azure application secret

.PARAMETER TenantName
Insert Microsoft Azure TenantName. Like contoso.onmicrosoft.com

.PARAMETER ApiType
Determens which Oauth resource to get token from

.EXAMPLE
New-AzureRest -ClientID 55555555-5555-5555-5555-555555555555 -ClientSecret f_Hj_Strp{?W3#'^WdXq!d/~p.RGwnyU(J68]>CADrE^ -TenantName
contoso.onmicrosoft.com -ApiType GraphApi

.INPUTS
System.String

.OUTPUTS
Function will return a string.

.NOTES
Version:        1.0
Author:         Nicholai Kjærgaard
Creation:       03/11/2018
Purpose/Change: Synopsis changed INPUTS added.
#>
function New-AzureOauthToken {
    param (
        
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]
        $ClientID,
        
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]
        $ClientSecret,

        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]
        $TenantName,

        # Parameter help description
        [Parameter(Mandatory=$true)]
        [ValidateSet("GraphApi","ManagementApi")]
        [string]
        $ApiType
    )

    switch ($ApiType) {
        "GraphApi" { 
            $Tokenbody = @{}
            $Tokenbody.Add('tenant',$TenantID)
            $Tokenbody.Add('client_id',$ClientID)
            $Tokenbody.Add('client_secret',$ClientSecret)
            $Tokenbody.Add('scope','https://graph.microsoft.com/.default')
            $Tokenbody.Add("grant_type",'client_credentials')
         }
         "ManagementApi" {
             # Body for Token request
            $Tokenbody = @{}
            $Tokenbody.Add("grant_type","client_credentials")
            $Tokenbody.Add("resource","https://management.azure.com")
            $Tokenbody.Add("client_id",$ClientID)
            $Tokenbody.Add("client_secret",$ClientSecret)
         }
        Default {}
    }

    # Header for Token request
    $Tokenheader = @{}
    $Tokenheader.Add('accept','application/json')

    # Token Request URL
    $TokenUri = switch ($ApiType) {
        GraphApi {"https://login.microsoftonline.com/$($TenantName)/oauth2/v2.0/token"}
        ManagementApi {"https://login.microsoftonline.com/$($TenantName)/oauth2/token"}
    }

    # Get token
    $tokenRequest = Invoke-RestMethod -Method Post -Uri $TokenUri -Headers $Tokenheader -Body $Tokenbody

    $AccessToken = $tokenRequest.access_token

    return $AccessToken
}