# n=5 model=out iset=I1 prefix14_class=6780
cmp P3, P1
mov S2, P1
mov S0, P2
cmovge S2, P3
cmovl P1, P3
cmp P2, P0
cmovg S0, P0
cmovle P2, P0
cmp S2, P2
cmovge P3, S2
cmovg S2, P2
cmovg P2, P3
mov P2, S0
cmp S0, P1
