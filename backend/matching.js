/**
 * Matching Algorithm for CafeSense
 * Calculates match percentage between UserProfile and Cafe
 */

function calculateMatch(userProfile, cafe) {
  if (!userProfile) return 100;

  let totalWeight = 0;
  let matchedWeight = 0;

  // 1. Space Styles Match (Weight = 3)
  if (userProfile.spaceStyle && userProfile.spaceStyle.length > 0) {
    totalWeight += 3;
    const cafeStyles = cafe.space_styles ? cafe.space_styles.split(',').map(s => s.trim().toLowerCase()) : [];
    const userStyles = userProfile.spaceStyle.map(s => s.trim().toLowerCase());
    const overlaps = userStyles.filter(s => cafeStyles.includes(s));

    const styleScore = overlaps.length / userStyles.length;
    matchedWeight += styleScore * 3;
  }

  // 2. Amenities Match (Weight = 3)
  if (userProfile.amenities && userProfile.amenities.length > 0) {
    totalWeight += 3;
    const cafeAmenities = cafe.amenities ? cafe.amenities.split(',').map(a => a.trim().toLowerCase()) : [];
    const userAmenities = userProfile.amenities.map(a => a.trim().toLowerCase());
    const overlaps = userAmenities.filter(a => cafeAmenities.includes(a));

    const amenityScore = overlaps.length / userAmenities.length;
    matchedWeight += amenityScore * 3;
  }

  // 3. Flavor Preference Match (Weight = 4)
  if (userProfile.flavorPreference) {
    const fp = userProfile.flavorPreference;
    const flavorKeys = ['roastLevel', 'acidity', 'body', 'sweetness', 'process'];
    const dbKeys = ['roast_level', 'acidity', 'body', 'sweetness', 'process'];

    let flavorTotal = 0;
    let flavorMatched = 0;

    for (let i = 0; i < flavorKeys.length; i++) {
      const userVal = fp[flavorKeys[i]];
      const cafeVal = cafe[dbKeys[i]];

      if (userVal && userVal.trim()) {
        flavorTotal++;
        if (userVal.trim().toLowerCase() === (cafeVal || '').trim().toLowerCase()) {
          flavorMatched++;
        }
      }
    }

    if (flavorTotal > 0) {
      totalWeight += 4;
      matchedWeight += (flavorMatched / flavorTotal) * 4;
    }
  }

  // 4. Purpose Match (Weight = 2)
  if (userProfile.mainPurpose && userProfile.mainPurpose.trim()) {
    totalWeight += 2;
    const purpose = userProfile.mainPurpose.toLowerCase();
    const tagline = (cafe.tagline || '').toLowerCase();
    const description = (cafe.description || '').toLowerCase();

    let purposeScore = 0.5;
    if (purpose.includes('học') || purpose.includes('làm việc') || purpose.includes('work')) {
      if (tagline.includes('work') || tagline.includes('focus') || description.includes('việc') || description.includes('tập trung')) {
        purposeScore = 1.0;
      } else {
        purposeScore = 0.4;
      }
    } else if (purpose.includes('thư giãn') || purpose.includes('đọc sách') || purpose.includes('relax')) {
      if (tagline.includes('focus') || description.includes('đọc sách') || description.includes('thư giãn') || description.includes('yên tĩnh')) {
        purposeScore = 1.0;
      } else {
        purposeScore = 0.5;
      }
    }
    matchedWeight += purposeScore * 2;
  }

  if (totalWeight === 0) return 90;

  const matchPercent = Math.round((matchedWeight / totalWeight) * 100);
  return Math.min(100, Math.max(0, matchPercent));
}

module.exports = {
  calculateMatch
};
