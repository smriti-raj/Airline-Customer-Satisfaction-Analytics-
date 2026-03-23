-- Create database
CREATE DATABASE airline_satisfaction_db;

-- Use the database
USE airline_satisfaction_db;
LOAD DATA INFILE '"C:\Data Set\Airline+Passenger+Satisfaction\Airline_passenger_satisfaction.csv"'
INTO TABLE your_table
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Passenger Dimension
CREATE TABLE dim_passenger (
    passenger_id INT PRIMARY KEY,
    gender VARCHAR(10),
    age INT,
    customer_type VARCHAR(20)
);
-- Flight Dimension
CREATE TABLE dim_flight (
    flight_id INT PRIMARY KEY,
    type_of_travel VARCHAR(20),
    class VARCHAR(20),
    flight_distance INT,
    departure_delay INT,
    arrival_delay INT
);
-- Service Dimension
CREATE TABLE dim_service (
    service_id INT PRIMARY KEY,
    dep_arr_time_convenience INT,
    ease_of_online_booking INT,
    checkin_service INT,
    online_boarding INT,
    gate_location INT,
    onboard_service INT,
    seat_comfort INT,
    leg_room_service INT,
    cleanliness INT,
    food_and_drink INT,
    inflight_service INT,
    inflight_wifi_service INT,
    inflight_entertainment INT,
    baggage_handling INT
);
-- Fact Table
CREATE TABLE fact_satisfaction (
    fact_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    service_id INT,
    satisfaction VARCHAR(30),
    satisfied_flag INT,
    FOREIGN KEY (passenger_id) REFERENCES dim_passenger(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES dim_flight(flight_id),
    FOREIGN KEY (service_id) REFERENCES dim_service(service_id)
);
CREATE TABLE stg_airline (
    ID INT,
    Gender VARCHAR(10),
    Age INT,
    Customer_Type VARCHAR(20),
    Type_of_Travel VARCHAR(20),
    Class VARCHAR(20),
    Flight_Distance INT,
    Departure_Delay INT,
    Arrival_Delay INT,
    Departure_and_Arrival_Time_Convenience INT,
    Ease_of_Online_Booking INT,
    Check_in_Service INT,
    Online_Boarding INT,
    Gate_Location INT,
    On_board_Service INT,
    Seat_Comfort INT,
    Leg_Room_Service INT,
    Cleanliness INT,
    Food_and_Drink INT,
    In_flight_Service INT,
    In_flight_Wifi_Service INT,
    In_flight_Entertainment INT,
    Baggage_Handling INT,
    Satisfaction VARCHAR(40)
);
-- Passenger
INSERT INTO dim_passenger
SELECT DISTINCT
    ID AS passenger_id,
    Gender,
    Age,
    Customer_Type
FROM stg_airline;
-- Flight
INSERT INTO dim_flight
SELECT DISTINCT
    ID AS flight_id,
    Type_of_Travel,
    Class,
    Flight_Distance,
    Departure_Delay,
    COALESCE(Arrival_Delay, 0) AS Arrival_Delay
FROM stg_airline;
-- Service
INSERT INTO dim_service
SELECT DISTINCT
    ID AS service_id,
    Departure_and_Arrival_Time_Convenience,
    Ease_of_Online_Booking,
    Check_in_Service,
    Online_Boarding,
    Gate_Location,
    On_board_Service,
    Seat_Comfort,
    Leg_Room_Service,
    Cleanliness,
    Food_and_Drink,
    In_flight_Service,
    In_flight_Wifi_Service,
    In_flight_Entertainment,
    Baggage_Handling
FROM stg_airline;
-- POPULATE FACT TABLE
INSERT INTO fact_satisfaction
SELECT
    ID AS fact_id,
    ID AS passenger_id,
    ID AS flight_id,
    ID AS service_id,
    Satisfaction,
    CASE 
        WHEN Satisfaction = 'satisfied' THEN 1 
        ELSE 0 
    END AS satisfied_flag
FROM stg_airline;

