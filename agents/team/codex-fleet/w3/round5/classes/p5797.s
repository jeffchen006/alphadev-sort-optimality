# n=5 model=out iset=I1 prefix14_class=5797
cmp P0, P2
mov S2, P2
cmovl S2, P0
cmovge P2, P0
cmp P1, P3
mov S0, S2
cmovg P0, P1
cmovge P1, P3
cmovg P3, P0
cmp P1, S0
mov S1, P3
cmovg S2, P1
cmovle S0, P1
cmp P2, S1
