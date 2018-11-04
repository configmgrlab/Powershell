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

    Write-Host $LastName

    # Create Hashtable
    $SpecialChar = @{}

    # Add Special char to hashtable
    $SpecialChar['å'] = 'aa'
    $SpecialChar['æ'] = 'ae'
    $SpecialChar['ø'] = 'oe'

    # Replace special characters in first name if it contains it
    $SpecialChar.Keys | ForEach-Object {$FirstName = $FirstName.Replace($_, $SpecialChar[$_])}

    # Replace special characters in last name if it contains it
    $SpecialChar.Keys | ForEach-Object {$LastName = $LastName.Replace($_, $SpecialChar[$_])}

    Write-Host $LastName

    # Create SamAccountName
    $FirstName = $FirstName.Substring(0,$CharFirstName)
    $LastName = $LastName.Substring(0,$CharLastName)

    #$SamAccount = $FirstName + $LastName
    
    #Write-Output $SamAccount
}