import '../domain/models/district.dart';
import '../domain/models/repair_notice.dart';
import '../domain/models/tanker.dart';

/// In-memory seed data standing in for a future backend/API.
class MockData {
  MockData._();

  static final DateTime _now = DateTime.now();

  static List<District> districts() => [
        District(
          id: 'gwarinpa',
          name: 'Gwarinpa',
          area: 'AMAC',
          status: OutageStatus.outage,
          lastUpdated: _now.subtract(const Duration(hours: 3)),
          daysWithoutWater: 9,
        ),
        District(
          id: 'wuse2',
          name: 'Wuse II',
          area: 'AMAC',
          status: OutageStatus.intermittent,
          lastUpdated: _now.subtract(const Duration(hours: 1)),
          daysWithoutWater: 2,
        ),
        District(
          id: 'garki',
          name: 'Garki',
          area: 'AMAC',
          status: OutageStatus.supplied,
          lastUpdated: _now.subtract(const Duration(minutes: 40)),
        ),
        District(
          id: 'lugbe',
          name: 'Lugbe',
          area: 'AMAC',
          status: OutageStatus.outage,
          lastUpdated: _now.subtract(const Duration(hours: 6)),
          daysWithoutWater: 21,
        ),
        District(
          id: 'kubwa',
          name: 'Kubwa',
          area: 'Bwari',
          status: OutageStatus.outage,
          lastUpdated: _now.subtract(const Duration(hours: 5)),
          daysWithoutWater: 14,
        ),
        District(
          id: 'maitama',
          name: 'Maitama',
          area: 'AMAC',
          status: OutageStatus.supplied,
          lastUpdated: _now.subtract(const Duration(hours: 2)),
        ),
        District(
          id: 'jabi',
          name: 'Jabi',
          area: 'AMAC',
          status: OutageStatus.intermittent,
          lastUpdated: _now.subtract(const Duration(hours: 4)),
          daysWithoutWater: 3,
        ),
        District(
          id: 'karu',
          name: 'Karu',
          area: 'AMAC',
          status: OutageStatus.outage,
          lastUpdated: _now.subtract(const Duration(hours: 8)),
          daysWithoutWater: 17,
        ),
      ];

  static List<RepairNotice> repairNotices() => [
        RepairNotice(
          id: 'n1',
          districtId: 'gwarinpa',
          title: 'Burst trunk main at 3rd Avenue',
          description:
              'FCT Water Board crews are repairing a burst trunk main affecting the whole of Gwarinpa. '
              'Tankered water is being deployed to worst-hit streets in the meantime.',
          status: NoticeStatus.inProgress,
          issuedAt: _now.subtract(const Duration(days: 2)),
          expectedResolution: _now.add(const Duration(days: 1)),
        ),
        RepairNotice(
          id: 'n2',
          districtId: 'lugbe',
          title: 'Booster pump replacement',
          description:
              'The booster pump station serving Lugbe phase 1 failed. A replacement unit has been ordered '
              'and installation is scheduled once it arrives.',
          status: NoticeStatus.scheduled,
          issuedAt: _now.subtract(const Duration(days: 5)),
          expectedResolution: _now.add(const Duration(days: 4)),
        ),
        RepairNotice(
          id: 'n3',
          districtId: 'kubwa',
          title: 'Scheduled pipeline maintenance',
          description:
              'Routine maintenance on the Kubwa distribution line. Supply will resume in phases.',
          status: NoticeStatus.inProgress,
          issuedAt: _now.subtract(const Duration(days: 3)),
          expectedResolution: _now.add(const Duration(days: 2)),
        ),
        RepairNotice(
          id: 'n4',
          districtId: 'karu',
          title: 'Power outage at treatment plant',
          description:
              'Extended grid outage has left the treatment plant on limited generator capacity, reducing output.',
          status: NoticeStatus.scheduled,
          issuedAt: _now.subtract(const Duration(days: 1)),
        ),
        RepairNotice(
          id: 'n5',
          districtId: 'wuse2',
          title: 'Valve replacement completed',
          description:
              'The faulty valve on Aminu Kano Crescent has been replaced. Pressure is being restored.',
          status: NoticeStatus.resolved,
          issuedAt: _now.subtract(const Duration(days: 6)),
          expectedResolution: _now.subtract(const Duration(days: 1)),
        ),
      ];

  static List<Tanker> tankers() => [
        Tanker(
          id: 't1',
          vendorName: 'AquaFlow Tankers',
          districtId: 'gwarinpa',
          capacityLitres: 10000,
          pricePerTrip: 25000,
          rating: 4.8,
          completedDeliveries: 214,
          phone: '+2348012345001',
        ),
        Tanker(
          id: 't2',
          vendorName: 'Kaduna Water Express',
          districtId: 'gwarinpa',
          capacityLitres: 5000,
          pricePerTrip: 15000,
          rating: 4.5,
          completedDeliveries: 98,
          phone: '+2348012345002',
        ),
        Tanker(
          id: 't3',
          vendorName: 'Jos Plateau Tankers',
          districtId: 'lugbe',
          capacityLitres: 15000,
          pricePerTrip: 32000,
          rating: 4.6,
          completedDeliveries: 156,
          phone: '+2348012345003',
        ),
        Tanker(
          id: 't4',
          vendorName: 'Reliable H2O',
          districtId: 'kubwa',
          capacityLitres: 10000,
          pricePerTrip: 24000,
          rating: 4.9,
          completedDeliveries: 301,
          phone: '+2348012345004',
        ),
        Tanker(
          id: 't5',
          vendorName: 'Speedy Tankers Ltd',
          districtId: 'karu',
          capacityLitres: 5000,
          pricePerTrip: 14000,
          rating: 4.2,
          completedDeliveries: 47,
          phone: '+2348012345005',
        ),
        Tanker(
          id: 't6',
          vendorName: 'Wuse Water Movers',
          districtId: 'wuse2',
          capacityLitres: 20000,
          pricePerTrip: 40000,
          rating: 4.7,
          completedDeliveries: 189,
          available: false,
          phone: '+2348012345006',
        ),
      ];
}
