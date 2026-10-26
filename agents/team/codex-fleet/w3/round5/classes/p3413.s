# n=5 model=out iset=I1 prefix14_class=3413
mov S2, P2
cmp P3, P2
cmovg S2, P3
cmovl P2, P3
cmp P1, P0
cmovge P3, P1
cmovge P1, P0
cmovl P3, P0
cmovl P0, P1
mov S0, S2
cmp P2, P1
cmovle P0, P2
cmovg P1, P2
mov P0, P1
