# n=5 model=out iset=I1 prefix14_class=579
cmp P3, P2
cmovle S2, P2
cmovg S2, P3
cmovge P3, P2
mov P2, S2
cmp P0, P1
cmovge S0, P0
mov S1, P3
cmovge P0, P1
cmovge P1, S0
cmp P1, P2
cmovg S2, P1
cmovl P2, P1
cmp P0, P3
