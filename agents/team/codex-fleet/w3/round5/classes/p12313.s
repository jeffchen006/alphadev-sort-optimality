# n=5 model=out iset=I1 prefix14_class=12313
cmp P1, P2
cmovle S0, P1
cmovl P1, P2
cmovg S0, P2
mov P2, P0
cmp P3, P2
cmovle P2, P3
cmovg P0, P3
cmp P2, S0
cmovge S2, P2
cmovg P2, S0
mov P2, P0
cmovge S0, S2
cmp P2, P1
