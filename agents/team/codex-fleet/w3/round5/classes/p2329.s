# n=5 model=out iset=I1 prefix14_class=2329
mov S1, P3
mov S0, P0
cmp P0, P1
cmovl P0, P1
cmovg S0, P1
cmp S1, P2
cmovle P3, P2
cmovge S1, P2
cmp P0, P3
cmovle S2, P3
cmovle P3, P0
cmovg S2, P0
cmp S1, S0
cmovle P2, S0
