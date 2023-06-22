# Pool3D
Project for simulation of physics (private, simple project, really nothing interesting)

W tym projekcie stworzyłem pomieszczenie, w którym niczym pociski latają ze sobą kulki 3d.
Inspiracją była kolektura lotto wraz z ich maszynami losującymi.

Kulki i ściany to staticBody, zatem nie mają wbudowanej fizyki. Cały ich ruch, wykrywanie
i obsługa kolizji ze ścianami oraz innymi kulkami został zaimplementowany ręcznie.

Wykorzystuję optymalizację w postaci liczenia odległości tylko od ścian, w które
kulka uderzy w najbliższej kolejności oraz w postaci segmentowania przestrzeni
i grupowania kulek, co pozwala na znacznie rzadsze sprawdzanie kolizji.

Ponadto za pomocą lewego przycisku myszy możliwe jest obracanie kamerą i rozglądanie
się po pomieszczeniu.
