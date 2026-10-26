# n=5 model=out iset=I1 prefix14_class=1662
cmp P2, P3
mov S1, P1
mov S2, P3
cmovge P3, P2
cmovge P2, S2
cmp P1, P0
mov S0, P2
cmovg S1, P0
cmovge P0, P1
cmp P2, S1
cmovl P2, S1
cmovle S1, S0
cmp P0, P3
cmovle S2, P3
