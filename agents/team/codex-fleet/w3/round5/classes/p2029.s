# n=5 model=out iset=I1 prefix14_class=2029
cmp P0, P2
cmovg S2, P2
cmovg P2, P0
cmovg P0, S2
mov S1, P1
cmp P3, P1
cmovg S1, P3
mov S2, P0
cmovl P1, P3
cmp S1, P2
mov S0, P2
cmovge P2, S1
cmovle S0, S1
mov P2, S0
