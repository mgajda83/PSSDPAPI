Function Remove-SDPRequestNote
{
	<#
	.SYNOPSIS
		Delete Request Note by id

	.PARAMETER RequestId
		Request id

	.PARAMETER NoteId
		Note id

	.EXAMPLE
		$Status = Remove-SDPRequestNote -RequestId 54321 -NoteId 12345

	.NOTES
		Author: Michal Gajda

	.LINK
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/requests/request_note.html#delete-request-note
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Parameter(Mandatory=$true,
			ValueFromPipeline)]
		[Int]$RequestId,
		[Parameter(Mandatory=$true)]
		[Int]$NoteId
	)

	Begin
	{
		#Create headers
		if(!$MyInvocation.BoundParameters.ContainsKey("UriSDP"))
		{
			if($Global:UriSDP)
			{
				$UriSDP = $Global:UriSDP
			} else {
				Write-Error "UriSDP parameter is required or run Set-SDPApiConnection first." -ErrorAction Stop
			}
		}
		if(!$MyInvocation.BoundParameters.ContainsKey("ApiKey"))
		{
			if($Global:ApiKey)
			{
				$ApiKey = $Global:ApiKey
			} else {
				Write-Error "ApiKey parameter is required or run Set-SDPApiConnection first." -ErrorAction Stop
			}
		}
	}

	Process
	{
		$InvokeParams = @{
			UriSDP = $UriSDP
			ApiKey = $ApiKey
			Method = "DELETE"
			EntityUri = "/api/v3/requests/$RequestId/notes/$NoteId"
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($NoteId,"Delete request note by id"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.response_status
		}

		#Return result
		if($MyInvocation.BoundParameters.ContainsKey("Debug"))
		{
			Return $Result
		} else {
			Return $Results
		}
	}

	End{}
}
