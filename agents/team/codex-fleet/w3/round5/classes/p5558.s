# n=5 model=out iset=I1 prefix14_class=5558
mov S2, P2
cmp P2, P1
cmovge P2, P1
cmovle S2, P1
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
cmovl P3, S0
cmp P2, P3
mov P1, P3
cmovg P1, P2
cmovl P3, P2
cmp S2, P0
cmovle S0, S2
