# n=5 model=out iset=I1 prefix14_class=9722
cmp P1, P2
cmovg S0, P2
cmovge P2, P1
mov S2, P0
mov S1, P2
cmovg P1, S0
cmp P3, P0
cmovg S2, P3
cmovl P0, P3
cmp S2, P2
cmovle P2, S2
cmovg S1, S2
cmp P1, P0
mov S1, P1
