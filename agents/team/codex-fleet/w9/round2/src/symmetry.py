"""Count comparison-order equivalence under residual input symmetries."""
import json
from orders import HERE,TRANS

def main():
    inventory=json.loads((HERE/'artifacts/orders.json').read_text());out=[]
    for row in inventory['families']:
        flags=[bytes(f) for f in row['flags']];target=tuple(flags);maps=set()
        for tr in TRANS:
            transformed=[]
            for i,f in enumerate(flags):
                g=bytes(f[t] for t in tr);h=bytes(2-x for x in g)
                transformed.append((min(g,h),i))
            transformed.sort()
            if tuple(x[0] for x in transformed)!=target:continue
            image=tuple(next(j for j,x in enumerate(transformed) if x[1]==i) for i in range(8))
            maps.add(image)
        def orbit(order):return {tuple(image[i] for i in order) for image in maps}
        valid={tuple(o) for o in row['valid_flag_orders']}
        known={q for order in row['original_orders'] for q in orbit(order)}
        reps=sorted({min(orbit(o)) for o in valid})
        new=[o for o in reps if o not in known]
        assert all(orbit(o)<=valid for o in valid)
        out.append({'family':row['id'],'comparison_permutations_from_input_symmetry':len(maps),'valid_order_orbits':len(reps),
                    'known_orders_with_symmetry':len(known),'new_order_orbits':new,
                    'representation_new_but_known_by_symmetry':len(set(map(tuple,row['new_flag_orders']))&known)})
    result={'families':out,'valid_order_orbits':sum(r['valid_order_orbits'] for r in out),
            'new_order_orbits':sum(len(r['new_order_orbits']) for r in out),
            'representation_new_but_known_by_symmetry':sum(r['representation_new_but_known_by_symmetry'] for r in out)}
    (HERE/'artifacts/symmetry.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result),flush=True)

if __name__=='__main__':main()
