#include <iostream>
#include <chrono>
#include <iomanip>
#include <vector>
#include <cmath>

using namespace std::chrono;

// Helper function to print time as Timestamp64 constructor arguments
template <typename Clock, typename Duration>
void print_timestamp64_args(const std::chrono::time_point<Clock, Duration>& tp) {
    auto tt = Clock::to_time_t(tp);
    auto ns = duration_cast<nanoseconds>(tp.time_since_epoch()) % 1000000000;
    std::tm* gmt = std::gmtime(&tt);
    std::cout << gmt->tm_year + 1900 << ", "
              << gmt->tm_mon + 1 << ", "
              << gmt->tm_mday << ", "
              << gmt->tm_hour << ", "
              << gmt->tm_min << ", "
              << gmt->tm_sec << ", "
              << ns.count();
}

// Custom floor function
template <typename D>
system_clock::time_point custom_floor(const system_clock::time_point& tp, const D& d) {
    auto duration_since_epoch = tp.time_since_epoch();
    auto floored_duration = duration_cast<D>(duration_since_epoch) - 
        duration_cast<D>(duration_since_epoch) % d;
    return system_clock::time_point(floored_duration);
}

// Helper function to convert period to Julia Dates type
std::string period_to_julia(const nanoseconds& period) {
    if (period < microseconds(1)) return "Nanosecond(" + std::to_string(period.count()) + ")";
    if (period < milliseconds(1)) return "Microsecond(" + std::to_string(duration_cast<microseconds>(period).count()) + ")";
    if (period < seconds(1)) return "Millisecond(" + std::to_string(duration_cast<milliseconds>(period).count()) + ")";
    if (period < minutes(1)) return "Second(" + std::to_string(duration_cast<seconds>(period).count()) + ")";
    if (period < hours(1)) return "Minute(" + std::to_string(duration_cast<minutes>(period).count()) + ")";
    if (period < days(1)) return "Hour(" + std::to_string(duration_cast<hours>(period).count()) + ")";
    return "Day(" + std::to_string(duration_cast<days>(period).count()) + ")";
}

int main() {
    // Define test times (only non-negative dates)
    std::vector<system_clock::time_point> test_times = {
        system_clock::from_time_t(0) + nanoseconds(123456789), // 1970-01-01 with some nanoseconds
        system_clock::from_time_t(1577923199), // 2019-12-31 23:59:59
        system_clock::from_time_t(1577923199) + nanoseconds(123456789), // 2019-12-31 23:59:59 with some nanoseconds
        system_clock::from_time_t(1893456000) + nanoseconds(123456789), // 2030-01-01 00:00:00 with some nanoseconds
    };

    // Define test periods (only positive periods)
    std::vector<std::pair<std::string, nanoseconds>> test_periods = {
        {"1 nanosecond", nanoseconds(1)},
        {"3 nanoseconds", nanoseconds(3)},
        {"7 nanoseconds", nanoseconds(7)},
        {"10 nanoseconds", nanoseconds(10)},
        {"1 microsecond", microseconds(1)},
        {"3 microseconds", microseconds(3)},
        {"7 microseconds", microseconds(7)},
        {"10 microseconds", microseconds(10)},
        {"1 millisecond", milliseconds(1)},
        {"3 milliseconds", milliseconds(3)},
        {"7 milliseconds", milliseconds(7)},
        {"10 milliseconds", milliseconds(10)},
        {"1 second", seconds(1)},
        {"3 seconds", seconds(3)},
        {"7 seconds", seconds(7)},
        {"10 seconds", seconds(10)},
        {"1 minute", minutes(1)},
        {"3 minutes", minutes(3)},
        {"7 minutes", minutes(7)},
        {"10 minutes", minutes(10)},
        {"1 hour", hours(1)},
        {"3 hours", hours(3)},
        {"7 hours", hours(7)},
        {"10 hours", hours(10)},
    };

    // Generate test cases
    for (const auto& tp : test_times) {
        std::cout << "# Original time: Timestamp64(";
        print_timestamp64_args(tp);
        std::cout << ")\n";

        for (const auto& [period_name, period] : test_periods) {
            auto floored = custom_floor(tp, period);
            std::cout << "@test floor(Timestamp64(";
            print_timestamp64_args(tp);
            std::cout << "), " << period_to_julia(period) << ") == Timestamp64(";
            print_timestamp64_args(floored);
            std::cout << ")\n";
        }
        std::cout << "\n";
    }

    return 0;
}
