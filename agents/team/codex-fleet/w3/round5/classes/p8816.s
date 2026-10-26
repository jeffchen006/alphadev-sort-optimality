# n=5 model=out iset=I1 prefix14_class=8816
cmp P0, P1
mov S2, P1
cmovle S2, P0
cmovg P1, P0
cmp P2, P3
mov S0, P2
cmovg S0, P3
mov P0, S0
cmovg P3, P2
cmp P3, P1
cmovg S1, P1
cmovge P1, P3
cmovg P3, S1
mov P1, P3
