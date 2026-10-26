# n=5 model=out iset=I1 prefix14_class=9398
mov S0, P2
cmp P1, P2
cmovg S0, P1
mov S2, P0
cmovge P1, P2
cmp P3, S2
cmovle S2, P3
cmovl P3, P0
cmp P1, S2
cmovge P0, P1
cmovg P1, S2
cmovge S2, P0
cmp P3, S0
cmovge P0, P3
