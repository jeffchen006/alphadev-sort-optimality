# n=5 model=out iset=I1 prefix14_class=4737
cmp P0, P2
cmovle S0, P0
cmovg S0, P2
cmovl P0, P2
cmp P1, P3
cmovge P2, P3
mov S1, S0
cmovge P3, P1
cmovge P1, P2
cmp P1, S1
cmovg S1, P1
cmovg P1, S0
cmp P3, P0
mov S0, S1
