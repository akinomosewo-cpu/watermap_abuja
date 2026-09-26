import 'package:flutter_test/flutter_test.dart';
import 'package:watermap_abuja/domain/services/cost_splitter.dart';

void main() {
  group('CostSplitter.splitEvenly', () {
    test('splits an evenly divisible amount equally', () {
      final shares = CostSplitter.splitEvenly(totalPrice: 30000, flatLabels: ['Flat A', 'Flat B', 'Flat C']);
      expect(shares.length, 3);
      for (final s in shares) {
        expect(s.shareAmount, 10000);
      }
      expect(CostSplitter.sharesReconcile(shares, 30000), isTrue);
    });

    test('distributes remainder kobo without losing money', () {
      final shares = CostSplitter.splitEvenly(totalPrice: 100, flatLabels: ['A', 'B', 'C']);
      // 100 / 3 = 33.33..., so two flats get 33.34 and one gets 33.33 (order-dependent).
      final total = shares.fold<double>(0, (sum, s) => sum + s.shareAmount);
      expect(total, closeTo(100, 0.001));
      expect(CostSplitter.sharesReconcile(shares, 100), isTrue);
    });

    test('throws when no flats are given', () {
      expect(() => CostSplitter.splitEvenly(totalPrice: 1000, flatLabels: []), throwsArgumentError);
    });

    test('single flat gets the full amount', () {
      final shares = CostSplitter.splitEvenly(totalPrice: 27000, flatLabels: ['Flat A']);
      expect(shares.single.shareAmount, 27000);
    });
  });

  group('CostSplitter.splitByWeight', () {
    test('splits proportionally to weights', () {
      final shares = CostSplitter.splitByWeight(
        totalPrice: 40000,
        flatLabels: ['1BR', '3BR'],
        weights: [1, 3],
      );
      expect(shares[0].shareAmount, 10000);
      expect(shares[1].shareAmount, 30000);
      expect(CostSplitter.sharesReconcile(shares, 40000), isTrue);
    });

    test('reconciles exactly even with rounding remainders', () {
      final shares = CostSplitter.splitByWeight(
        totalPrice: 10000,
        flatLabels: ['A', 'B', 'C'],
        weights: [1, 1, 1],
      );
      expect(CostSplitter.sharesReconcile(shares, 10000), isTrue);
    });

    test('throws on mismatched lengths', () {
      expect(
        () => CostSplitter.splitByWeight(totalPrice: 1000, flatLabels: ['A', 'B'], weights: [1]),
        throwsArgumentError,
      );
    });

    test('throws on non-positive weights', () {
      expect(
        () => CostSplitter.splitByWeight(totalPrice: 1000, flatLabels: ['A', 'B'], weights: [1, 0]),
        throwsArgumentError,
      );
    });
  });
}
