INSERT INTO TrainList (TrainName,CurrentStation) 
  VALUES
  ('SouthExpress1','Invercargill'),
  ('SouthernCargo','ChristChurch'),
  ('SouthExpress2','Gore'),
  ('SouthernCargo','Bluff'),
  ('PrimeMinistersTrain',null);

INSERT INTO [Routes] (Source, Destination, Distance)
  VALUES
  ('Bluff','Invercargill', 25.023),
  ('Invercargill','Bluff', 25.023),
  ('Invercargill','Gore',  63.953),
  ('Gore','Invercargill',  63.953),
  ('Dunedin','Christchurch',  254.892),
  ('Christchurch','Queenstown',  197.357),
  ('Invercargill','Dunedin',163.953);
