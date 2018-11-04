<#
.SYNOPSIS
Function for SAMAcountname creation

.DESCRIPTION
Function will create SAMAccountname from first name and last name

.PARAMETER FirstName
Input parameter for fist name

.PARAMETER LastName
Input paramter for last name

.PARAMETER CharFirstName
Parameter for how many characters from first name should be used. NB maximum 3 characters

.PARAMETER CharLastName
Parameter for how many characters from last name should be used. NB maximum 3 characters

.EXAMPLE
New-SamAccountName -FirstName Søren -LastName Kjærsgård -CharFirstName 3 -CharLastName 3

.NOTES
 Special danish letter will be replaced like this

 æ = ae
 ø = oe
 å = aa

#>
function New-SamAccountName {
    param (
        # First Name insert
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $FirstName,

        # Last Name insert
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LastName,
        
        # Number of char of first name
        [Parameter(Mandatory=$true)]
        [Validateset('1','2','3')]
        [string]
        $CharFirstName,

        # Number of char of first name
        [Parameter(Mandatory=$true)]
        [Validateset('1','2','3')]
        [string]
        $CharLastName

    )

    # Create Hashtable
    $SpecialChar = @{}

    # Add Special char to hashtable
    $SpecialChar['å'] = 'aa'
    $SpecialChar['æ'] = 'ae'
    $SpecialChar['ø'] = 'oe'

    # Set first and last name to low characters
    $FirstName = $FirstName.ToLower()
    $LastName = $LastName.ToLower()

    # Replace special characters in first name if it contains it
    $SpecialChar.Keys | ForEach-Object {$FirstName = $FirstName.Replace($_, $SpecialChar[$_])}

    # Replace special characters in last name if it contains it
    $SpecialChar.Keys | ForEach-Object {$LastName = $LastName.Replace($_, $SpecialChar[$_])}

    # Create SamAccountName
    $FirstName = $FirstName.Substring(0,$CharFirstName)
    
    $LastName = $LastName.Substring(0,$CharLastName)
    
    $SamAccount = $FirstName + $LastName
    
    # Return SAMAccountName
    Write-Output $SamAccount
}