# Disaster Recovery Plan

## Objectives

- **RTO (Recovery Time Objective):** < 1 hour for production.
- **RPO (Recovery Point Objective):** < 15 minutes for production.

## Strategy

Pilot Light with Warm Standby in secondary region `us-west-2`.

### Primary Region

- Active production traffic in `us-east-1`.
- Multi-AZ deployments across 3 AZs.
- Continuous backups to AWS Backup vault.

### Secondary Region

- Core data replicated (RDS read replica, S3 cross-region replication).
- Minimal compute ready to scale (Warm Standby).
- Route 53 health checks monitor primary endpoint.

## Failover Steps

1. **Detect:** Route 53 health check fails in primary region.
2. **Promote:** Promote RDS read replica in DR region to standalone writer.
3. **Scale:** Increase ASG desired capacity in DR region.
4. **Route:** Update Route 53 failover record to point to DR region ALB.
5. **Verify:** Run smoke tests against DR environment.

## Failback Steps

1. Restore primary region services.
2. Re-establish replication from DR to primary.
3. Update Route 53 to route traffic back to primary.
4. Validate primary environment health.

## Automation

- Backup module supports `enable_cross_region_copy = true`.
- Future enhancement: Lambda functions for automated failover orchestration.
