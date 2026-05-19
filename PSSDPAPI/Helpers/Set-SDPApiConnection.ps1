Function Set-SDPApiConnection
{
    <#
	.SYNOPSIS
	    Save API connection data in new session

	.PARAMETER UriSDP
	    Uri to SDP Api

	.PARAMETER ApiKey
	    Technican APIKey

	.PARAMETER IgnoreSSL
	    Ignore ssl certificate validation

	.NOTES
		Author: Michal Gajda
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
    param (
        [Parameter(Mandatory=$true)]
        [String]$UriSDP,
        [Parameter(Mandatory=$true)]
        [String]$ApiKey,
		[Switch]$IgnoreSSL
    )

    Begin
    {
		if($IgnoreSSL)
		{
			Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
			[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
			[System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		}
    }

    Process
    {
		If ($PSCmdlet.ShouldProcess($UriSDP,"Save connection data"))
		{
			if($UriSDP -notmatch "http://|https://")
			{
				$UriSDP = "https://" + $UriSDP
			}

			Set-Variable -Name UriSDP -Value $UriSDP.Trim().TrimEnd('/') -Scope global
			Set-Variable -Name ApiKey -Value $ApiKey.Trim() -Scope global
		}
    }

    End{}
}
