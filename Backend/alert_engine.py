# alert_engine.py

from datetime import datetime

# BIS (Bureau of Indian Standards) Safe Drinking Limits
PH_MIN = 6.5
PH_MAX = 8.5
TDS_MAX = 500        # ppm
TURBIDITY_MAX = 5    # NTU


def analyze_water_quality(ph: float, tds: float, turbidity: float):
    """
    Analyze water quality based on threshold values.
    Returns:
        {
            "status": "Safe" / "Unsafe",
            "alerts": [list of alert messages],
            "timestamp": current time
        }
    """

    alerts = []

    # pH Check
    if ph < PH_MIN:
        alerts.append("Water is too acidic (Low pH).")
    elif ph > PH_MAX:
        alerts.append("Water is too alkaline (High pH).")

    # TDS Check
    if tds > TDS_MAX:
        alerts.append("High TDS level detected (Excess dissolved solids).")

    # Turbidity Check
    if turbidity > TURBIDITY_MAX:
        alerts.append("High turbidity detected (Water appears cloudy).")

    # Final Status
    if len(alerts) == 0:
        status = "Safe"
    else:
        status = "Unsafe"

    return {
        "status": status,
        "alerts": alerts,
        "timestamp": datetime.now()
    }