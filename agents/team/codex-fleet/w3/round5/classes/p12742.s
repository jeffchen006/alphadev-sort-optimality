# n=5 model=out iset=I1 prefix14_class=12742
mov S1, P2
cmp P3, P2
cmovle S1, P3
cmovg P2, P3
cmp P0, P1
mov S0, P0
cmovl P0, P1
cmovle P1, S0
cmp P1, S1
cmovge S2, S1
cmovge S1, P1
cmovge P1, S2
cmp P0, P2
mov P1, S1
