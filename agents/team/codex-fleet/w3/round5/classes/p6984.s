# n=5 model=out iset=I1 prefix14_class=6984
cmp P3, P0
mov S0, P0
cmovge S0, P3
cmovge P3, P0
mov P0, P2
cmp P1, P2
cmovg P0, P1
mov S2, S0
cmovl P2, P1
cmp S2, P0
cmovg S2, P0
cmovle S0, P0
cmp P2, P3
cmovle P0, P3
