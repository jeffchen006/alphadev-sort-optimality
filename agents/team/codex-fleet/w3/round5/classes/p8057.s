# n=5 model=out iset=I1 prefix14_class=8057
mov S2, P1
cmp P3, S2
mov S1, P0
cmovl P1, P3
cmovle P3, S2
mov S0, P1
cmp P0, P2
cmovg P0, P2
cmovge P2, S1
cmp P1, P0
cmovle P1, P0
cmovg S0, P0
cmp P3, P2
mov S0, P1
