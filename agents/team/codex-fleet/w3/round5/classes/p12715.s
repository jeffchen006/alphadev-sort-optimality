# n=5 model=out iset=I1 prefix14_class=12715
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
mov S0, P0
cmovle S2, P3
cmp S0, P1
mov S1, S2
cmovle S0, P1
cmovl P1, P0
cmp P1, P2
cmovge P0, P2
cmovg P2, P1
cmovge P1, P0
cmp S2, S0
