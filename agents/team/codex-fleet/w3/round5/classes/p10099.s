# n=5 model=out iset=I1 prefix14_class=10099
cmp P1, P3
cmovg S1, P1
cmovle S1, P3
cmovl P3, P1
cmp P2, P0
cmovg S2, P2
cmovge P2, P0
cmovg P0, S2
cmp S1, P0
cmovle S0, S1
cmovle S1, P0
mov P1, P3
cmovl P0, S0
cmp P2, P3
