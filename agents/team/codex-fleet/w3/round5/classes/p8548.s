# n=5 model=out iset=I1 prefix14_class=8548
cmp P0, P1
cmovle S2, P0
mov S0, P2
cmovle P0, P1
cmovl P1, S2
cmp P2, P3
cmovge P2, P3
cmovle S0, P3
cmp S0, P0
cmovg S1, S0
cmovg S0, P0
cmovg P0, S1
cmp P2, P1
cmovle S1, P1
