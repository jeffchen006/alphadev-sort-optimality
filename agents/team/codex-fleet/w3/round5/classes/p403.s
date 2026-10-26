# n=5 model=out iset=I1 prefix14_class=403
mov S1, P0
cmp P2, P0
cmovg S1, P2
cmovl P0, P2
mov S2, P1
cmp S2, P3
cmovge P1, P3
cmovg P3, S2
mov P2, P1
cmp P2, P0
cmovle P2, P0
cmovg P1, P0
cmp S1, P3
mov S0, P3
