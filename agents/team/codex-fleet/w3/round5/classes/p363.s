# n=5 model=out iset=I1 prefix14_class=363
mov S0, P2
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
mov S1, P3
cmp P3, P0
cmovge P3, P0
mov P2, P1
cmovg P0, S1
cmp P3, P1
cmovl P2, P3
mov S2, P0
cmovle P3, P1
cmp S0, S2
