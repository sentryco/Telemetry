import Foundation
/**
 * With the help of Telemetry, Google Analytics is able to track events and screen views. The Google Analytics Measurement protocol, which is, is used in the class. (https://developers.google.com/analytics/devguides/collection/protocol/v1/reference).
 * - Remark: Since Google has officially discontinued the ability to track mobile analytics through Google Analytics, new apps are urged to use Firebase.
 * - Remark: This library transforms screen views into pageviews, and you must configure new tracking properties as websites in the Google Analytics admin console.
 * - Remark: The app bundle identifier, which can be set to any custom value for privacy purposes, will be used as a dummy hostname for tracking pageviews and screen views.
 */
public class Telemetry {}
