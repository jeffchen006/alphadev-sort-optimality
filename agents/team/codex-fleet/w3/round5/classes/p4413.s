# n=5 model=out iset=I1 prefix14_class=4413
mov S1, P0
mov S2, P2
cmp S1, P3
cmovle P0, P3
cmovg S1, P3
cmp P2, P1
cmovge S2, P1
mov S0, S1
cmovge P1, P2
cmp P0, P1
cmovle P3, P0
cmovl P0, P1
cmovle P1, P3
mov P0, P1
