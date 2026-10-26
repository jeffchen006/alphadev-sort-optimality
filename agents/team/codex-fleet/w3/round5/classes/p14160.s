# n=5 model=out iset=I1 prefix14_class=14160
cmp P1, P3
cmovle S2, P3
cmovle P3, P1
mov S1, P2
cmovl P1, S2
cmp P0, S1
cmovge P2, P0
mov S0, P1
cmovge P0, S1
cmp S0, P2
cmovg P1, P2
cmovge P2, S0
cmp P0, P3
cmovg S0, P0
