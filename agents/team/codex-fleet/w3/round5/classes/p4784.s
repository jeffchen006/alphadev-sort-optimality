# n=5 model=out iset=I1 prefix14_class=4784
cmp P1, P0
cmovl S1, P1
cmovle P1, P0
cmovl P0, S1
cmp P2, P3
cmovg S0, P2
cmovge P2, P3
cmovle S0, P3
mov S2, P1
mov P3, P0
cmp P2, P0
cmovge P3, P2
cmovle P0, P2
cmp S2, S0
