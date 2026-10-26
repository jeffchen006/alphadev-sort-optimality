# n=5 model=out iset=I1 prefix14_class=6809
cmp P2, P1
cmovle S0, P1
cmovg S0, P2
cmovl P1, P2
cmp P0, P3
cmovge P2, P3
mov S1, P1
cmovg P3, P0
cmovg P0, P2
cmp P3, S0
cmovle S2, S0
cmovle S0, P3
cmovg S2, P3
cmp P0, S1
