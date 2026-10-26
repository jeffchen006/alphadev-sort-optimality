# n=5 model=out iset=I1 prefix14_class=11750
cmp P2, P3
cmovg S1, P2
cmovge P2, P3
mov S2, P1
cmovg P3, S1
cmp P1, P0
mov S0, P3
cmovg S2, P0
cmovl P1, P0
cmp P1, P3
cmovle P3, P1
cmovge S0, P1
cmp S2, P2
mov P1, P2
