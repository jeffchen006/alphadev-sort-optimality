# n=5 model=out iset=I1 prefix14_class=10142
cmp P0, P2
cmovg S0, P2
cmovle S0, P0
cmovge P2, P0
mov S1, P1
cmp S1, P3
mov S2, P2
cmovg P1, P3
cmovle S1, P3
cmp S1, S2
cmovg P2, S1
cmovle S2, S1
cmp P1, S0
cmovl P3, S0
