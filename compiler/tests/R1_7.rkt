;test variable overshaddowing
(let ([x 10])
  (+ (let ([x 20])
       (+ x 12))
     x))