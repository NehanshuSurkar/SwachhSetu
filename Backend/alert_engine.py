

from datetime import datetime

# BIS (Bureau of Indian Standards) Safe Drinking Limits
PH_MIN = 6.5
PH_MAX = 8.5
TDS_MAX = 500        # ppm
TURBIDITY_MAX = 5    # NTU

def analyze_water_quality(ph: float, tds: float, turbidity: float, temperature: float):
    """
    Analyze water quality based on threshold values.
    Returns:
        {
            "status": "Safe" / "Moderate" / "Unsafe",
            "alerts": [list of alert messages],
            "timestamp": current time
        }
    """

    alerts = []

    # pH Check
    if ph < PH_MIN:
        alerts.append("Water is too acidic (Low pH - below 6.5)")
    elif ph > PH_MAX:
        alerts.append("Water is too alkaline (High pH - above 8.5)")

    # TDS Check
    if tds > TDS_MAX:
        alerts.append(f"High TDS level detected ({tds} ppm - exceeds 500 ppm)")

    # Turbidity Check
    if turbidity > TURBIDITY_MAX:
        alerts.append(f"High turbidity detected ({turbidity} NTU - cloudy water)")

    # Temperature Check (additional safety)
    if temperature > 35:
        alerts.append("Water temperature is unusually high")
    elif temperature < 10:
        alerts.append("Water temperature is unusually low")

    # Final Status
    if len(alerts) == 0:
        status = "Safe"
    elif len(alerts) <= 2:
        status = "Moderate"
    else:
        status = "Unsafe"

    return {
        "status": status,
        "alerts": alerts,
        "timestamp": datetime.now()
    }