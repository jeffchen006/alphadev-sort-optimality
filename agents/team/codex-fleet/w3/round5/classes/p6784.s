# n=5 model=out iset=I1 prefix14_class=6784
mov S2, P1
mov S0, P2
cmp P3, P1
cmovge S2, P3
cmovle P1, P3
cmp S0, P0
cmovl P2, P0
cmovg S0, P0
cmp S2, P2
cmovge P0, S2
cmovg S2, P2
mov P3, S2
cmovge P2, P0
cmp P1, S0
