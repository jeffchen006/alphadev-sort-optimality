# n=5 model=out iset=I1 prefix14_class=5450
cmp P3, P2
mov S2, P2
cmovle S2, P3
cmovl P3, P2
cmp P0, P1
mov S1, S2
cmovge P2, P1
cmovge P1, P0
cmovg P0, P2
cmp P0, S1
mov S0, P3
cmovle S1, P0
cmovle P0, S2
cmp S0, P1
