# n=5 model=out iset=I1 prefix14_class=14050
mov S0, P1
cmp P2, P1
cmovl P1, P2
mov S1, P3
cmovg S0, P2
cmp P0, P3
cmovle S1, P0
cmovge P3, P0
cmp S0, P3
cmovge P2, S0
cmovg S0, P3
cmovg P3, P2
mov S2, S1
cmp S1, P1
