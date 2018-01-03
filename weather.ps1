# Simple weather script that parses html data from yahoo.com
# Will break if yahoo changes html tags or classes used to get raw data

$tempTag = 'span'
$tempClass = 'Va(t)'
$cityTag = 'h1'
$cityClass = 'city Fz(2em)--sm Fz(3.7em)--lg Fz(3.3em) Fw(n) M(0) Trsdu(.3s) desktop_Lh(1) smartphone_Lh(1)'
$condClass = 'description Va(m) Px(2px) Fz(1.3em)--sm Fz(1.6em)'
$unitTag = 'button'
$unitClass = 'unit Tt(c) Fz(.2em) Fw(200) O(n) P(6px) Va(t) D(b) Lh(1em) Tsh($temperature-text-shadow) M(a) C(#fff)'
$dateTag = 'div'
$dateValue = Date +%x,%I:%M

$URL = 'https://www.yahoo.com/news/weather/'
$HTML = Invoke-WebRequest -Uri $URL
Write-Host "Retrieving weather information from $URL..."

function getData ($tag, $class) {
    (($HTML.ParsedHtml.getElementsByTagName($tag) | Where{$_.className -eq $class}).innerHtml)
}

$city = getData $cityTag $cityClass
$condition = getData $tempTag $condClass
$temp = getData $tempTag $tempClass
$unit = getData $unitTag $unitClass

$parm = @{
    City = $city
    Condition = $condition
    Temp = "$temp$unit"
    Time = $dateValue
}

New-Object -TypeName PSObject -Property $parm | ft -AutoSize