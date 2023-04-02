import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MarketShimmerWidget extends StatelessWidget {

  const MarketShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListView.separated(
        itemCount: 16,
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 10,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.03,
                          height: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 10,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 10,
                      color: Colors.white,
                    )
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (ctx, index) {
          return const Divider();
        },
      ),
    );
  }
}