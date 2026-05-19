function ConvertTo-Hashtable
{
    [CmdletBinding()]
    [OutputType('hashtable')]
    Param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    Process
    {
        ## Return null if the input is null. This can happen when calling the function
        ## recursively and a property is null
        if ($null -eq $InputObject)
        {
            Return $null
        }
        ## Check if the input is an array or collection. If so, we also need to convert
        ## those types into hash tables as well. This function will convert all child
        ## objects into hash tables (if applicable)
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
        {
            $Collection = @(
                Foreach($Object in $InputObject)
                {
                    ConvertTo-Hashtable -InputObject $Object
                }
            )
            ## Return the array but don't enumerate it because the object may be pretty complex
            Write-Output -NoEnumerate $Collection
        } elseif ($InputObject -is [PSObject]) { ## If the object has properties that need enumeration
            ## Convert it to its own hash table and return it
            $Hash = @{}
            foreach ($Property in $InputObject.PSObject.Properties) {
                $Hash[$Property.Name] = ConvertTo-Hashtable -InputObject $Property.Value
            }
            $Hash
        } else {
            ## If the object isn't an array, collection, or other object, it's already a hash table
            ## So just return it.
            $InputObject
        }
    }
}